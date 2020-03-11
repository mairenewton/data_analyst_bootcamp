view: user_order_facts {
  derived_table: {
    sql: select user_id,
      count(distinct id) as lifetime_orders,
      sum(sale_price) as lifetime_revenue
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue]
  }
}
