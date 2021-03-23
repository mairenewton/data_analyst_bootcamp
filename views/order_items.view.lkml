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

  # dimension_group: shipping_days {
  #   type:
  # }

  dimension: shipping_days {
    type: number
    description: "Days between Shipped Date and Delivered Date"
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
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

  measure: average_sales {
    type: average
    # value_format: "$#,##0.00"
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: average_spend_per_user {
    type:  number
    value_format_name: usd
    sql: 1.0*${total_sales}/NULLIF(${users.count},0) ;;
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}/NULLIF(${total_sales},0) ;;
  }

  measure: counts_of_orders {
    description: "Count of Unique Orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
   # value_format: "$#,##0.00"
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.is_email_source: "Yes"]
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

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
