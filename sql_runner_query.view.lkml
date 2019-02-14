view: sql_runner_query {
  derived_table: {
    sql: SELECT user_id, sum(sale_price), min(created_at), max(created_at), count(*) as count_of_orders
      from order_items
      group by 1
      limit 40
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

  dimension: sum {
    type: number
    sql: ${TABLE}.sum ;;
  }

  dimension_group: min {
    type: time
    sql: ${TABLE}.min ;;
  }

  dimension_group: max {
    type: time
    sql: ${TABLE}.max ;;
  }

  dimension: count_of_orders {
    type: number
    sql: ${TABLE}.count_of_orders ;;
  }

  set: detail {
    fields: [user_id, sum, min_time, max_time, count_of_orders]
  }
}
