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
  dimension_group: Shipping_days{
    type: duration
    sql_start: ${created_date} ;;
    sql_end: ${shipped_date} ;;
    intervals: [day]
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
  measure: Unique_orders {
    description: "count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }
  measure: total_sales{
    description: "Total sales"
    type: sum
    sql: ${sale_price} ;;
  }
  measure: average_sales {
    description: "average sales"
    type: average
    sql: $(${sale_price} ;;
  }
  measure: sales_from_email {
    type: sum
    filters: {field: users.traffic_source_is_email
              value: "Yes"}
    sql: ${sale_price};;
  }
  measure: percent_sales_from_email {
    type: number
    value_format_name: percent_2
    sql: 1.0*${sales_from_email}/NULLIF(${total_sales},0) ;;
  }
  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0*${total_sales}/${users.count} ;;
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
  dimension_group: day
  {
    type: duration
    intervals: [day]
    sql_start: ${shipped_raw};;
    sql_end: ${delivered_raw} ;;
  }
}
