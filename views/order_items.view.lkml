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

  measure: min_created_date {
    type: date_date
    sql: MIN(${created_date})  ;;
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

  measure: num_orders {
    type: count_distinct
    sql: ${order_id} ;;
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

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: eur
  }

  measure: total_sales_email {
    type: sum
    label: "Total sales from Email-Users"
    description: "filtered on traffic source Email respective to the user"
    filters: [users.is_email: "Yes"]
    value_format_name: eur
    sql: ${sale_price} ;;
  }

  measure: total_sales_email_pct {
    type: number
    label: "Total Sales Email Percentage"
    description: "Total Sales from Email-Users / Total Sales"
    value_format_name: percent_2
    sql: 1.0 * ${total_sales_email} / NULLIF(${total_sales}, 0) ;;
  }

  measure: avg_spent_per_user {
    type: number
    description: "total sales by users count"
    sql: 1.0 * ${total_sales} / NULLIF(users.count,0) ;;
    value_format_name: eur
  }

  measure: avg_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: eur
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

  dimension_group: shipped_delivered {
    type: duration
    timeframes: [date]
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
