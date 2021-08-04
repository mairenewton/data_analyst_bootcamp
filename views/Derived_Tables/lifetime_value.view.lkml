view: sql_runner_query {
  derived_table: {
    sql: select
      order_items.user_id,
      sum(order_items.sale_price) as lifetime_orders_value,
      count(distinct order_id) as lifetime_orders
      from
      order_items

      group by 1

       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders_value {
    type: number
    sql: ${TABLE}.lifetime_orders_value ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  measure: average_value {
    type: average
    sql: ${lifetime_orders_value} ;;
  }

  measure: average_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders_value, lifetime_orders]
  }
}
