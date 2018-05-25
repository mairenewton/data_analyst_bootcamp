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
    group_label: "ID Fields"
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    group_label: "ID Fields"
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
    value_format_name: usd
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
    group_label: "ID Fields"
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: number_of_orders {
    description: "A distinct count of the number of orders placed"
    type: count_distinct
    sql: ${order_id} ;;

  }

  measure: total_sales {
    type: sum
    sql:  ${sale_price} ;;
    value_format_name:  usd
    drill_fields: [order_detail_set*]
  }

  measure: total_sales_email {
    type: sum
    sql:  ${sale_price} ;;
    value_format_name:  usd
    drill_fields: [order_detail_set*]
    filters: {
      field: users.traffic_source
      value: "Email"
    }
  }


  measure: percent_email_sales {
    type: number
    sql: 100.0 * ${total_sales_email}/NULLIF(${total_sales},0) ;;
    value_format: "#.00\%"
  }

  measure: total_sales_completed {
    type: sum
    sql:  ${sale_price} ;;
    value_format_name:  usd
    drill_fields: [order_detail_set*]

    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: average_sales {
    type: average
    sql:  ${sale_price} ;;
    value_format_name:  usd
  }

  measure: percent_completed_sales {
    type:  number
    sql: ${total_sales_completed} / NULLIF(${total_sales}, 0)  ;;
  }

  # ----- Sets of fields for drilling ------

  set: order_detail_set {
    fields: [order_id, user_id, status, count, total_sales]
  }

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
