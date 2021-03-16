view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id { #MANY order items per order
    primary_key: yes #STEP 1
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

  dimension: order_id { #shopping cart ID
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
    hidden: yes
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

  measure: count_order_items {
    type: count
    drill_fields: [detail*]
  }

  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    description: "Sum of sale price"
    value_format_name: usd
    drill_fields: [order_id, user_id, users.city, count_orders, avg_sale_price]
  }

  measure: avg_sale_price {
    type: average
    sql: ${sale_price} ;;
    description: "Average of sale price"
    value_format_name: usd
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [ users.traffic_source: "Email"]
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}/${total_sale_price} ;;
  }

  measure: avg_spend_per_user {
    type: number
    value_format_name: usd
    sql: ${total_sale_price}/ ${users.count_users} ;;
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
