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

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
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
  }

  measure: number_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_detail_set*]
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [order_detail_set*]
  }

  measure: percent_completed_orders {
    type: number
    sql: (1.0*${number_of_completed_orders}) / nullif(${number_of_orders}, 0) ;;
    value_format_name: percent_2
    drill_fields: [order_detail_set*]
  }

  measure: number_of_completed_orders {
    type: count_distinct
    sql: ${order_id} ;;
    filters: {
      field: status
      value: "Complete"
    }
  }

  set: order_detail_set {
    fields: [order_id, user_id, status, total_sales]
  }




}
