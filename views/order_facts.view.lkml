view: order_facts {
  derived_table: {
    sql: SELECT order_id,
          user_id,
          count(*) as order_item_count,
          sum(sale_price) AS order_total
          FROM order_items
          GROUP BY 1,2
          ORDER BY 3 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_item_count {
    type: number
    sql: ${TABLE}.order_item_count ;;
  }

  dimension: order_total {
    type: number
    sql: ${TABLE}.order_total ;;
  }

  set: detail {
    fields: [order_id, user_id, order_item_count, order_total]
  }
}
