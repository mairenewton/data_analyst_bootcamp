view: order_facts {
  derived_table: {
    sql: SELECT order_items.order_id
       ,order_items.user_id
       ,COUNT(*) AS lifetime_order_items_count
       ,SUM(order_items.sale_price) AS lifetime_revenue
FROM order_items
GROUP BY order_id, user_id
ORDER BY item_count DESC
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    primary_key: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_items_count {
    type: number
    sql: ${TABLE}.lifetime_order_items_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: avg_items_per_order{
    type: average
    sql: ${lifetime_order_items_count} ;;
  }

  set: detail {
    fields: [order_id, user_id, lifetime_order_items_count, lifetime_revenue]
  }
}
