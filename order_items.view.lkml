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

  dimension: Shipping_days {
    type: number
    sql: DATEDIFF(day, ${shipped_date} , ${delivered_date};;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: distinct_number_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
  }

  measure: total_sales_email {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.Is_email_traffic_source
      value: "Yes"
    }
  }

  measure: percent_email_traffic_sales {
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_sales_email}/NULLIF(${total_sales},0) ;;
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: ${total_sales}/NULLIF(${users.count},0) ;;
  }

  measure: average_revenue_per_item {
    type: number
    value_format_name: usd
    sql: ${total_sales}/NULLIF(${count},0) ;;
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
