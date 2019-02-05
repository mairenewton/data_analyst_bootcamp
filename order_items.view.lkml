view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: shipping_days {
    label: "Shipping Time"
    description: "Number of days lapsed between shipping and delivery date"
    type: number
    sql: DATEDIFF(day,${shipped_date},${delivered_date}) ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: distinct_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales_volume {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: email_sales_volume {
    filters: {
      field: users.traffic_source_email_flag
      value: "Yes"
      }
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: email_sales_pct {
    value_format_name: percent_1
    type: number
    sql: 1.0*(${email_sales_volume}/NULLIF(${total_sales_volume},0)) ;;
  }

  measure: avg_user_spend {
    type: number
    sql: ${total_sales_volume}/${users.count} ;;
  }

  measure: avg_sales_volume {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  # ----- Sets of fields for drilling ------

  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
