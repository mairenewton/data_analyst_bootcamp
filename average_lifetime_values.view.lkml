view: average_lifetime_values {
  derived_table: {
    sql: SELECT
       order_items.user_id,
       COUNT(distinct order_items.order_id) AS lifetime_order_count,
      SUM(order_items.sale_price) AS lifetime_order_value
      FROM order_items
      GROUP BY order_items.user_id
       ;;
  }

  measure: average_lifetime_value {
    group_label: "Lifetime_Metrics"
    type: average
    sql: ${lifetime_order_value} ;;
    value_format: "$#.##"

  }

  measure: average_lifetime_count {
    group_label: "Lifetime_Metrics"
    type: average
    sql: ${lifetime_order_count} ;;

  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    hidden: yes
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_order_value {
    type: number
    hidden: yes
    sql: ${TABLE}.lifetime_order_value ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_order_value]
  }
}
