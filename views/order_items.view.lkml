view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      month_name,
      month_num,
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
    #hidden: yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
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

  dimension_group: shipping_days {
    type: duration
    intervals: [day, week, month, year]
    sql_start: ${shipped_raw} ;;  # often this is a single database column
    sql_end: ${delivered_raw} ;;  # often this is a single database column

  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: n_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    description: "Sum of sale price"
    sql: ${sale_price} ;;
    value_format: "$0.0"
  }

  measure: average_sales {
    type: average
    description: "Average of sale price"
    sql: ${sale_price} ;;
    value_format: "0.0"
  }

  measure: email_total_sales {
    type: sum
    description: "Sum of sale prices for user coming from email source"
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Email"]
    value_format: "0.0"
  }

  measure: pct_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${email_total_sales}/nullif(total_sales, 0) ;;
  }

  measure: avg_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0*${total_sales}/count_distinct(cast(${user_id} as string) ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_item_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
