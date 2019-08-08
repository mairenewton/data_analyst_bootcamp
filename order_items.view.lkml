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

  dimension: shipping_days {
    type: number
    sql: DATEDIFF(days, ${shipped_date}, ${delivered_date}) ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: distinct_orders {
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id} ;;
  }

  measure: distinct_users {
    type: count_distinct
    drill_fields: [detail*]
    sql: ${user_id} ;;
  }
  measure: total_sales {
    type: sum
    drill_fields: [detail*]
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sales {
    type: average
    drill_fields: [detail*]
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: sales_from_email_source{
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters:  {
      field: users.traffic_source
      value: "Email"
    }
  }

  measure: percent_sales_from_email{
    type: number
    value_format_name: percent_1
    sql: 1.0*${sales_from_email_source}/nullif(${total_sales},0) ;;
  }

  measure: average_spend_per_user{
    type: number
    value_format_name: usd
    sql: 1.0*${total_sales}/nullif(${distinct_users},0) ;;
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
