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

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: ship_and_order {
    type:  duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: distinct_orders {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_item_id} ;;
  }

  measure: tot_sales {
    description: "Sum of sale price"
    type:  sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: avg_sales {
    description: "Average of sale price"
    type:  average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_new_customer {
    type: sum
    sql:  ${sale_price};;
    filters: [ users.is_new_customer: "yes" ]
    value_format_name: usd_0
  }

  measure: total_sales_from_email {
    type: sum
    sql: ${sale_price};;
    filters: [ users.email_source: "yes"]
    value_format_name: usd
  }

  measure: pct_sales_from_email {
    type: number
    sql:  1*${total_sales_from_email}/NULLIF(${tot_sales},0);;
    value_format_name: percent_2
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
