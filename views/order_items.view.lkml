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
      date,
      week,
      month,
      month_name,
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
    # hidden: yes
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: Shipping_Days {
    type: duration
    sql_start: ${shipped_date}  ;;
    sql_end: ${delivered_date} ;;
    intervals: [day,hour,month,week,year]
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: Order_Count {
    type: count_distinct
    description: "A count of unique orders."
    sql: ${order_id} ;;
  }

  measure: Total_Sale_Price {
    description: "Sum of Sale Price"
    type: sum
    sql: ${sale_price} ;;
  }

  measure: Avg_Sale_Price {
    description: "Average of Sale Price"
    type: average
    sql: ${sale_price} ;;
  }

  measure: total_sales_email_source {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.EmailYesNo: "Yes"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: pct_email_sales {
    type: number
    sql: 1.0*${total_sales_email_source}/NULLIF(${Total_Sale_Price},0) ;;
    value_format_name: percent_1
  }

  measure: sales_per_user {
    type: number
    sql: ${Total_Sale_Price}/NULLIF(${users.count},0) ;;
    value_format_name: usd
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
