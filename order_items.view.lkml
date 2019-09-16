view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: since_first_order {
    type: duration
    sql_start: ${user_orders_fact.first_order_raw} ;;
    sql_end:  ${order_items.created_raw};;
  }

  dimension_group: since_first_order_ndt {
    type: duration
    sql_start: ${user_orders_fact_ndt.first_order_raw} ;;
    sql_end:  ${order_items.created_raw};;
  }

  dimension: shipping_days {
    type: number

    sql: ${delivered_date} - ${shipped_date};;
  }

  measure: min_created_date {
    type: date
    sql: min(${created_raw}) ;;
  }
  measure: max_created_date {
    type: date
    sql: max(${created_raw}) ;;
  }
  measure: email_user_total_sales {
    type: sum
    sql: ${sale_price};;
    filters:{
      field: users.traffic_source
      value: "Email"
    }
  }

  measure: percentage_email_user_total_sales {
    type: number
    value_format_name: percent_0
    sql: ${email_user_total_sales} / ${sale_price_total};;
  }

  measure: sth {
    type: number
    value_format_name: usd_0
    sql: ${sale_price_total} / ${user_count};;
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id};;
  }

  measure: sale_price_total {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: sale_price_avg {
    type: average
    label: "Average sale price"
    sql: ${sale_price} ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_order {
    type: count_distinct
    sql: ${order_id} ;;
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
