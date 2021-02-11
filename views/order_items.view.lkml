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

  dimension: days_to_ship {
    type:  duration_day
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
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

  ## Mesures
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_sales {
    type:  average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales {
    type:  sum_distinct
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_by_email {
    type:  sum_distinct
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.is_email_source: "Yes"]
  }

  measure: percent_sales_by_email {
    type:  number
    sql: 1.0*${total_sales_by_email}/NULLIF(${total_sales},0) ;;
    value_format_name: percent_0
  }

  measure: average_sales_by_email {
    type:  average
    sql: ${total_sales_by_email} ;;
    value_format_name: usd
    filters: [users.is_email_source: "Yes"]
  }

  measure: distinct_order {
    type:  count_distinct
    sql: ${order_id} ;;
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
