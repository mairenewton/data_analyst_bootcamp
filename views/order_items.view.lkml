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
  dimension: delivery_time {
    type: string
    sql: datediff(Days,${delivered_date},${shipped_date} ;;
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
  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
  }
measure: average_Sales {
  type: average
  sql: ${sale_price} ;;
}
measure: email_sourced_sales{
  type: sum
  sql: ${sale_price} ;;
  filters:
  {
    field: users.is_traffic_from_email
    value: "Yes"
  }
}
measure: email_sales_percentage {
  description: "Percentage of  Sales sourced from Email"
  type: number
  sql: ${email_sourced_sales}/${total_sales};;
  value_format_name: percent_2
}
measure: spend_per_user {
  description: "Average spend per User"
  type: number
  sql: ${total_sales}/nullif(${users.count},0);;
  value_format_name: usd_0
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
measure: order_count {
  type: count_distinct
  sql: ${order_id} ;;
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
}
