view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    hidden: yes
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
    group_label: "ID Fields"
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    label: "Number of Items Ordered"
    type: count
  }

  measure: number_of_orders {
    description: "A distinct count of the number of orders placed"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_id, order_detail_set*]
  }

  measure: total_sales_completed_orders {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_id, order_detail_set*]
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: percent_completed_sales {
    type: number
    sql: ${total_sales_completed_orders} / nullif(${total_sales}, 0) ;;
    value_format_name: percent_2
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_detail_set*]
  }


set: order_detail_set {
  fields: [user_id, status, count, total_sales]
}








}
