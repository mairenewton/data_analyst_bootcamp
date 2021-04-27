view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: shipping_days {
    description: "Use this to get the difference between shipped and delivered dates."
    type: number
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
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

  measure: count_of_orders {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
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

  measure: total_sales {
    group_label: "All Measures"
    drill_fields: [id, created_month]
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_email_users {
    group_label: "All Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_source: "Yes"]
  }

  measure: percentage_sales_email_source {
    group_label: "All Measures"
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_sales_email_users} / NULLIF(${total_sales}, 0) ;;
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
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
