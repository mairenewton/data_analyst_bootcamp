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
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: shipping_days_sqlcalc {
    type: number
    sql: DateDiff(day,  ${shipped_date}, ${delivered_date});;
  }

  dimension: shipping_days_using_looker_function {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
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
    value_format: "0.00" #Added this format to have only two decimal places
    sql: ${TABLE}.sale_price ;;
  }

  dimension: sale_price_with_tax {
    type: number
    value_format: "0.00" #Added this format to have only two decimal places
    sql: ${sale_price} *1.1 ;;
  }

  dimension: is_expensive {
    label: "Is this Product $$$"
    type: yesno
    sql:  ${sale_price_with_tax} >20 ;;

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
    drill_fields: [detail*]
  }

  measure: count_email_only {
    type: count
    filters: {
      field: users.traffic_source
      value: "Email"
    }
  }


  measure: sum_of_sales {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: sum_of_sales_with_tax {
    type: sum
    sql: ${sale_price_with_tax} ;;
  }

  measure: avg_of_sales {
    type: average
    sql: ${sale_price} ;;
  }

  measure: avg_of_sales_with_tax {
    type: average
    sql: ${sale_price_with_tax} ;;
  }

  measure: avg_sales_per_person{
    type: number
    sql: ${sum_of_sales} / ${users.count} ;;
  }

  #exercise 2
  measure: distinct_orders_ex2 {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: total_sales_ex2 {
    type: sum
    sql: ${sale_price} ;;
    value_format: "$0.00"
  }

  measure: avg_sales_ex2 {
    type: average
    sql: ${sale_price} ;;
    value_format: "$0.00"
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
