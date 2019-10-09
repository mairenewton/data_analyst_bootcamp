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

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: shipping_days {
    type: number
    sql: datediff(days, ${shipped_date}, ${delivered_date}) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_shipping_days {
    type: average
    sql: ${shipping_days} ;;
  }

  measure: count_distinct_orders {
    description: "Count distinct Orders"
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [order_id, created_date, shipped_date, sale_price]
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [order_id, created_date, shipped_date, sale_price]
  }

  measure: average_sales {
    type: average
    # value_format: "$#.00;($#.00)"
    sql: ${sale_price} ;;
    drill_fields: [order_id, created_date, shipped_date, sale_price]
  }

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price} ;;
    filters:  {
      field: users.is_new_user
      value: "Yes"
    }
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters:  {
      field: users.is_email_source
      value: "Yes"
    }
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_sales_email_users} / NULLIF(${total_sales}, 0) ;;
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
