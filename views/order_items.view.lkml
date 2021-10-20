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


  dimension_group: shipping_days {
    type: duration
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
    intervals: [day, week, year]
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


  measure: unique_order_count {
    description: "A count of unique orders"
    type:  count_distinct
    sql: ${order_id} ;;
  }


  measure: total_sales {
    description: "Sum of sale price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_new_customer: "Yes"]
    value_format_name: usd
  }


  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Email"]
  }

  measure: average_sale_price {
    type:  average
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
