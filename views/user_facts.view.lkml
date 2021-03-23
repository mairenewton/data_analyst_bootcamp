view: user_facts {
  derived_table: {
    sql: select
      user_id,
      count(distinct order_id) as lifetime_orders,
      sum(sale_price) as lifetime_value
      from public.order_items
      group by user_id
       ;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}.lifetime_value ;;
  }

  measure: average_lifetime_value {
    type: average
    sql:${lifetime_value}  ;;
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }


}
