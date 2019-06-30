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
    group_label: "ID Group"
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    group_label: "ID Group"
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

  dimension: shipping_days {
    type: number
    sql: datediff('days', ${shipped_raw}, ${delivered_raw}) ;;
  }

  dimension_group: shipping_days_2 {
    type: duration
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
    intervals: [day]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    group_label: "Sales Measures"
    type: sum
    sql: ${sale_price} ;;
    value_format: "$#,##0.00"
    drill_fields: [users.city, total_sales]
    }

  measure: averager_sales {
    group_label: "Sales Measures"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
#     value_format: "$#,##0.00"
    }

  measure: total_sales_from_email {
    group_label: "Sales Measures"
    hidden: yes
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: users.is_email
      value: "Yes"
    }
  }

  measure: percent_of_sales_from_email {
    group_label: "Sales Measures"
    label: "PCT Sales from Email"
    description: "This is an example of a description"
    type: number
    sql: 1.0*${total_sales_from_email}/nullif(${total_sales},0) ;;
    value_format_name: percent_1
  }

  measure: average_spend_per_user {
    group_label: "Sales Measures"
    type: number
    sql: 1.0*${total_sales}/nullif(${users.count_of_users},0) ;;
    value_format_name: usd
    drill_fields: [users.city, average_spend_per_user_2]
  }

  measure: average_spend_per_user_2 {
    hidden: yes
    group_label: "Sales Measures"
    type: number
    sql: 1.0*${total_sales}/nullif(${users.count_of_users},0) ;;
    value_format_name: usd
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
