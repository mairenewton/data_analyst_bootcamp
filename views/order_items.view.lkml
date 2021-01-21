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

  # dimension: profit {
  #   type: number
  #   sql: ${sale_price} - ${inventory_items.cost} ;;
  # }

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

  ## BRAD Add

  dimension_group: shipping {
    type: duration
    intervals: [day]
    sql_start:  ${shipped_date} ;;
    sql_end:  ${delivered_date} ;;
  }

  measure: total_items_ordered {
    type: count
  }

  measure: total_users {
    type:  count_distinct
    sql:  ${user_id} ;;
  }

  measure: total_orders{
    type: count_distinct
    sql:  ${order_id} ;;
  }

  measure: total_sales {
    value_format_name: usd
    description: "Sum of sale price"
    type: sum
    sql:  ${sale_price};;
  }

  measure: average_sales {
    value_format_name: usd
    description: "average sale price"
    type: average
    sql:  ${sale_price};;
  }

  measure: total_sales_new_users {
    value_format_name: usd
    type:  sum
    sql:  ${sale_price} ;;
    filters: [ users.is_new_customer: "yes" ]
  }

  measure: total_sales_email_users {
    value_format_name: usd
    type:  sum
    sql:  ${sale_price} ;;
    filters: [ users.is_email_source: "yes"]
  }

  measure: pct_sales_email_source {
    type:  number
    value_format_name: percent_2
    sql:  1.0 * ${total_sales_email_users} / NULLIF( ${total_sales}, 0) ;;
  }

  measure: avg_sales_per_user {
    type:  number
    value_format_name: usd
    sql:  1.0 * ${total_sales} / NULLIF( ${users.count}, 0) ;;
  }
}
