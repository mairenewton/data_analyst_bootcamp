view: order_value {
  derived_table: {
    sql: select user_id,sum(sale_price) as sum_value, count(order_id) as sum_order from public.order_items
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

  dimension: sum_value {
    type: number
    sql: ${TABLE}.sum_value ;;
  }

  dimension: sum_order {
    type: number
    sql: ${TABLE}.sum_order ;;
  }

  measure: Avg_value {
    type: average
    sql: ${TABLE}.sum_value ;;
  }

  measure: Avg_order {
    type: average
    sql: ${TABLE}.sum_order ;;
  }

  set: detail {
    fields: [user_id, sum_value, sum_order]
  }
}
