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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: exercise_count {
    type: count_distinct
    #drill_fields: [detail*]
    sql: ${order_id};;
    label: "Distinct Orders (for exercise)"
  }

  dimension_group: shipping_duration_in {
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day]
  }

  measure: sum_total_sales {
    label: "😎"
    type: sum
    sql: ${sale_price} ;;
  }

  measure: sum_total_sales_from_email {
   # label: "😎"
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.traffic_source
      value: "Email"
    }
  }

  measure: percentage_total_sales_from_email {
    type: number
    sql:  ${sum_total_sales_from_email} / nullif( ${sum_total_sales}, 0) ;;
    value_format_name: usd

  }

  measure: user_total_sales{
    type: sum_distinct
    sql: ${sale_price};;
    sql_distinct_key: ${user_id} ;;

  }

  measure: percentage_user_total_sales {
    type: number
    sql:  ${user_total_sales}/${sum_total_sales} ;;
  }

  measure: avg_sales {
    type: average
    sql: ${sale_price} ;;
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
