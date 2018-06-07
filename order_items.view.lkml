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

  dimension: shipping_time {
    type: number
    sql: datediff('day', ${shipped_date}, ${delivered_date}) ;;
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

  measure: number_of_orders {
    label: "Order Count"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: orders_per_user {
    type: number
    sql: 1.0*(${number_of_orders})/nullif(${users.count}, 0) ;;
    value_format_name: decimal_2
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_completed_orders {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: percent_sales_completed_orders {
    type: number
    sql: ${total_sales_completed_orders}/nullif(${total_sales}, 0) ;;
    value_format_name: percent_1
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count_distinct_users {
    type: count_distinct
    sql: ${user_id} ;;
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
