view: user_fact {
  derived_table: {
    sql: SELECT
      order_items.user_id AS user_id
      ,COUNT(distinct order_items.order_id)AS lifetime_order_count
      ,SUM(order_items.sale_price)AS lifetime_revenue
      FROM order_items
      Group by 1
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

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
