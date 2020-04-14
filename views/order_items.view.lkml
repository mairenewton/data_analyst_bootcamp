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

  dimension: days_between_order_ship_and_delivered {
    hidden: yes
    type: number
    sql: datediff('day', ${shipped_raw}, ${delivered_raw}) ;;
  }

# Best practice vs days_on_our_site dimension
  dimension_group: between_order_ship_date_and_delivered_date {
    type: duration
    intervals: [hour, day, week, month]
    sql_start: ${shipped_raw};;
    sql_end: ${delivered_raw} ;;
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
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }

  dimension: sale_price_times_user_age {
    type: number
    sql:  ${sale_price} * ${users.age} ;;
  }

  dimension: sale_price_bucket {
    type: tier
    sql: ${sale_price} ;;
    tiers: [10,20,30,40]
    style: integer
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

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_of_orders {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: percent_of_total_sales_from_email {
    description: "Percent of total sales from email as traffic source."
    type: number
    value_format_name: percent_2
    sql: ${total_sales_from_email} / ${total_sales} ;;
  }

  measure: total_sales {
    type: sum
    value_format_name: usd
    # value_format_name: decimal_5
    sql: ${sale_price} ;;
  }

  measure: total_sales_from_non_returned_items {
    description: "Total sales from items that were not returned to us."
    type: sum
    value_format_name: usd
    filters: [returned_date: "NULL", delivered_date: "-NULL"]
    sql: ${sale_price} ;;
  }

  measure: total_sales_from_females {
    description: "Total sales from females."
    type: sum
    value_format_name: usd
    filters: [users.gender: "Female"]
    sql: ${sale_price} ;;
  }

  measure: total_sales_from_email {
    description: "Total sales from email as traffic source."
    type: sum
    value_format_name: usd
    filters: [users.traffic_source: "Email"]
    sql: ${sale_price} ;;
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
