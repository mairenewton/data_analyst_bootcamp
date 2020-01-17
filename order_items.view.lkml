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


dimension: shipping_days {
  type: number
  sql:  datediff(day,${shipped_raw},${delivered_raw}) ;;
}

dimension_group: shipping_days2 {
  type: duration
  convert_tz: no
intervals: [day,hour]
sql_start: ${shipped_raw} ;;
sql_end: ${delivered_raw} ;;
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
measure: count_order {
  type: count_distinct
  sql: ${order_id};;
}

measure:  average_sales{
  type: average
  sql:  ${sale_price} ;;
  value_format_name: decimal_0
}

measure: total_sales_users {
  type: sum
  sql:  ${sale_price} ;;
  value_format_name: usd_0
  filters: {
    field: users.traffic_source
    value: "Email"
      }
  }

  measure: percentage_users {
    type: number
    value_format_name: percent_0
    sql:  1.0*${total_sales_users}/Nullif(${total_sales},0) ;;

  }
measure:  cc{
  type: count_distinct
  sql: ${users.id} ;;

}
measure:  average_example{
  type: number
  value_format_name: usd_0
  sql:   1.0*${total_sales}/Nullif(${cc},0) ;;
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
