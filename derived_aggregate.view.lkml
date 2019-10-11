view: derived_aggregate {
  derived_table: {
    sql: select  user_id, count(order_id), sum(sale_price), min(created_at), max(created_at)
      from order_items
      group by user_id
       ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
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

  set: detail {
    fields: [user_id, count, sum, min_time, max_time]
  }
}
