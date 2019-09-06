view: user_facts_2 {
  derived_table: {
    sql: SELECT user_id, COUNT(inventory_item_id) as lifetime_order_count,
      SUM(sale_price) as lifetime_revenue
      FROM order_items
      GROUP BY 1
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

  measure: average_order_count {
    type: average
    sql: ${lifetime_order_count} ;;
    value_format_name: decimal_2
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
