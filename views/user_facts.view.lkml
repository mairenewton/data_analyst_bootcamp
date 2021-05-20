view: user_facts {
  derived_table: {
    sql: SELECT
           order_items.user_id AS user_id
          ,COUNT(distinct order_items.order_id) AS lifetime_order_count
          ,SUM(order_items.sale_price) AS lifetime_revenue
      FROM order_items
      GROUP BY user_id
       ;;
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: average_lifetime_revenue {
    type: average
    value_format_name: decimal_0
    sql: ${lifetime_revenue} ;;
  }

  measure: average_lifetime_orders_count {
    type: average
    value_format_name: usd
    sql: ${lifetime_order_count} ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
