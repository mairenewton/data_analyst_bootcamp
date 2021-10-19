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
      order_item_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

  dimension_group: diff_ship_order_date {
  type: duration
  intervals: [day,week,month]
  sql_start: ${created_date} ;;
  sql_end: ${delivered_date} ;;
}

measure: count_orders {
  type: count_distinct
  description: "A count of unique orders"
  sql: ${order_id} ;;
}

measure: total_sales_price {
  type: sum
  description: "Total sales price"
  sql: ${sale_price} ;;
  value_format_name: usd_0
}

measure: avg_sales_price {
  type: average
  description: "Average sales price"
  sql: ${sale_price} ;;
  value_format_name: usd_0
}

measure: total_sales_new_user {
  type: sum
  sql: ${sale_price} ;;
  filters: [users.is_new_customer:  "Yes"]
}

measure: sales_email_traffic {
  type: sum
  sql: ${sale_price} ;;
  filters: [users.traffic_source: "Email"]
}

measure: avg_spend_user {
  type: number
  value_format_name: usd
  sql: 1.0*${total_sales_price}/NULLIF(${users.count},0) ;;
}


}
