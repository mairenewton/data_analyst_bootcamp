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
    type: number
    # hidden: yes
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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: shipping_days {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension_group: shipping_days2 {
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day, month, year]
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

  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_profit {
    type: sum
    sql: ${sale_price} - ${products.cost} ;;
    value_format_name: usd
  }

  measure: total_revenue_completed_orders {
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
  }

  measure: order_count  {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales  {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: email_total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.traffic_source: "Email"]
  }

  measure: email_sales_percentage {
    type: number
    value_format_name: percent_1
    sql: 1.0*${email_total_sales}/NULLIF(${total_sales},0) ;;
  }

  measure: average_sales {
    type: average
    sql:  ${sale_price} ;;
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
