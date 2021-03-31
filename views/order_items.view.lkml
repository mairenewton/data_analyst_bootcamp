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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }


  dimension: days_between_ship_deliver {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  measure: order_count {
    description: "a count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    group_label: "Sales Metrics"
    sql: ${sale_price} ;;
    value_format: ""
  }

  measure: total_email_sales {
    type: sum
    group_label: "Sales Metrics"
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.is_email: "Yes"]
  }

  measure: percentage_email {
    type: number
    group_label: "Sales Metrics"
    sql:  1.0*${total_email_sales} / NULLIF(${total_sales},0);;
    value_format_name: percent_1
  }

  measure: average_spend_user {
    type: number
    group_label: "Sales Metrics"
    value_format_name: usd
    sql: 1.0*${total_sales} / NULLIF(${users.count},0) ;;
  }

  measure: average_sale {
    type: average
    group_label: "Sales Metrics"
    sql: ${sale_price} ;;
    value_format_name: usd
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
