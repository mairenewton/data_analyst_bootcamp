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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_of_items{
    description: "a count of individual line items"
    type: count
  }

  measure: count_of_orders {
    description: "a count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sale_price {
    type: sum
    sql:  ${sale_price} ;;
  }

  measure: average_sale_price{
    type:  average
    sql: ${sale_price} ;;
  }

  dimension: shipping_days {
    type: number
    sql:DATEDIFF(day, ${shipped_date}, ${delivered_date} ;;
    }

  measure: total_sales_email_users {
    type:  sum
    sql:  ${sale_price} ;;
    filters: [
        users.traffic_source: "Email"
    ]
  }


  measure: percent_sales_email_users {
    type: number
    sql: 1.0 * ${total_sales_email_users} / NULLIF(${total_sale_price},0) ;;
    value_format_name: percent_1
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*(count ;;
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
