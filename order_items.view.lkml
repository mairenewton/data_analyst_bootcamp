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
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  dimension: shipping_days  {
    type:  number
    sql:  DATEDIFF(days, ${shipped_date}, ${delivered_date}) ;;
  }

  measure: avg_shipping_day {
    label: "Average Shipping Days"
    description: "Average time taken to deliver goods in days"
    type: average
    sql:  ${shipping_days} ;;
  }

  measure: order_count {
    label: "Distinct count of orders"
    description: "Counts the distinct number of orders"
    type:  count_distinct
    sql:  ${order_id} ;;
  }

  measure: total_sales {
    type:  sum
    sql:  ${sale_price} ;;
    value_format_name:  usd
    drill_fields: [detail*]
  }

  measure: total_sales_from_email {
    type:  sum
    label: "Total Sales from Email"
    description: "Total Sales from Email"
    sql:  ${sale_price};;
    value_format_name: usd
    filters: {
      field: users.is_email_source
      value: "Yes"
    }
  }

  measure: average_spend_per_user {
    type:  number
    label: " Average Spend per User"
    description: "Average spend per User"
    value_format_name: usd
    sql:  1.0 * ${total_sales} / NULLIF(${users.count},0) ;;
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
