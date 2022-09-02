view: derived_order_items {
  derived_table: {

    sql: SELECT order_items. order_id,
      COUNT(*) AS item_count,
      SUM(sale_price) AS lifetime_revenue
FROM public.order_items
GROUP BY order_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
  }

  set: detail {
    fields: [order_id, item_count, lifetime_revenue]
  }
}
