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

##practice exercise 2
  dimension_group: shipping_days {
    label: "Shipping Days"
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

#practice exercise 5
measure: distinct_orders {
  type: count_distinct
  sql: ${order_id} ;;
}

#practice exercise 6
measure: total_sales {
  type: sum
  value_format_name: usd
  sql: ${sale_price} ;;
}

#practice exercise 7
measure: average_sales {
  type:  average
  value_format_name: usd
  sql: ${sale_price} ;;
}

#practice exercise 8
measure: email_user_sales {
  type:  sum
  sql: ${sale_price} ;;
  value_format_name: usd
  filters: {
    field: users.is_email_source
    value: "Yes"
  }
}

#practice exercise 9
measure: email_sales_percentage {
  type: number
  value_format_name: percent_2
  sql: 1.0*${email_user_sales}/NULLIF(${total_sales},0) ;;
}

#practice exercise 10
measure: average_spend_per_user {
  type:  number
  value_format_name: usd
  sql:  1.0*${total_sales}/NULLIF(${users.count},0) ;;
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
