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

dimension: Days_Delivered {
  type: duration_day
  sql_start: ${shipped_date} ;;
  sql_end: ${delivered_date} ;;

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

  measure: Count_Distinct_Order {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: Total_Sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: Average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: total_sales_email {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.Email_or_not: "Yes"]
  }

  measure: percent_sale {
    type: percent_of_total
    sql: ${Total_Sales} ;;
#    filters:  [users.Email_or_not: "Yes"]
  }

  measure: first_order_date {
    type: date
    sql: Min(${created_date}) ;;
  }

  measure: latest_order_date {
    type: date
    sql: Max(${created_date}) ;;
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
