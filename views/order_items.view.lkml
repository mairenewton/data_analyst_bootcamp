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

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: eur_0
  }

  measure: avg_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: eur_0
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

  dimension: shipping_days {
    label: "Shipping Days"
    type: duration_day
    sql_start: ${shipped_date};;
    sql_end: ${delivered_date};;
}

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: distinct_number_of_orders {
    type: count_distinct
    sql: ${order_id} ;;
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

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_new_user: "Yes"]
  }

  measure: total_sales_web {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Website"]
  }

  measure: pct_sales_web {
    type: number
    sql: 1.0 *  total_sales_web/nullif(${total_sales}, 0);;
    value_format_name: percent_2
  }
}
