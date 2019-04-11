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

  dimension: shipping_days {
    type:  number
    sql:  DATEDIFF(day, ${shipped_raw}, ${delivered_raw}) ;;
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

  measure: distinct_count {
    type:  count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type:  sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: average_sales {
    type: average
    sql:  ${sale_price} ;;
    value_format_name: usd
  }

  measure: email_sales_total {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.is_traffic_source_email
      value: "Yes"
    }
    value_format_name: usd
  }

  measure: percent_sales_with_email {
    type: number
    sql:  1.0*${email_sales_total}/nullif(${total_sales},0) ;;
    value_format_name: percent_2
  }

  measure: average_spend_per_user {
    type: number
    sql:  1.0*${total_sales}/nullif(${users.count},0) ;;
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
