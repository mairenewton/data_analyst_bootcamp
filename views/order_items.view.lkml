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

  dimension: delivery_time_in_days {
    type: number
    sql: DATEDIFF(day,${created_date},${delivered_date}) ;;
  }

  dimension_group: delivery {
    type: duration
    sql_start: ${created_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day,week,month]
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count_order_items {
    group_label: "Counts"
    type: count
  }

  measure: count_of_orders {
    group_label: "Counts"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    drill_fields: [created_date,status,total_sales]
  }

  measure: average_item_sale {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: total_sales_from_email {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_traffic_email: "Yes"]
    value_format_name: usd_0
  }

  measure: percentage_sales_email {
    label: "% Sales Email"
    type: number
    sql: 1.0 * ${total_sales_from_email} / NULLIF(${total_sales},0) ;;
    value_format_name: percent_1
  }

}
