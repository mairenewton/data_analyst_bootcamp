view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      month_name,
      month_num,
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
    #hidden: yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
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
    label: "Order Status"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }
  dimension_group: since_placed {
    type: duration
    sql_start: ${created_raw} ;;
    sql_end: ${delivered_raw} ;;
    intervals: [minute,hour,day,week,month]
  }

  dimension: sale_prices {
    type: number
    sql: ${TABLE}.sale_price ;;
  }


 # dimension: sale_price {
 #   type: number
 #   sql: ${TABLE}.sale_price ;;
 # }

 # measure: average_sale_price {
 #   type: average
 #   sql: ${sale_price} ;;
 # }

  measure: avg_sale_price {
    type: average
    sql: ${sale_prices} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }
  measure: distinct_orders {
    type: count_distinct
    label: "Count Distinct Orders"
    sql: ${order_id} ;;
  }
  measure: total_sale_price  {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }
  measure: average_sale_price  {
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
}

measure: sales_from_email {
  type: sum
  filters: [users.traffic_source: "Email"]
  value_format_name: usd
  sql: ${sale_price}
  ;;
}




measure: avg_spent_per_user {
type: number
value_format_name: usd
sql: 1.0 * ${total_sale_price}/ NULLIF(${distinct_orders},0);;
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
