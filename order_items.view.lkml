view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    hidden: yes
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

  dimension: shipping_days {
    type: number
    sql: DATEDIFF(days, ${shipped_date}, ${delivered_date}) ;;
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

  measure: distinct_orders {
    description: "Distinct count of orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales {
    group_label: "Sales"
    type: sum
    sql: ${sale_price};;
    drill_fields: [detail*]
  }

  measure: total_sales_new_users{
    type: sum
    sql: ${sale_price};;
    filters: {
      field: users.is_new_customer
      value: "Yes"
    }
  }

  measure: avg_sales {
    group_label: "Sales"
    label: "Average Sales"
    description: "Average of Sale Price"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.is_email_source
      value: "Yes"
    }
  }

  measure: percentage_sales_email_source {
    type: number
    sql: ${total_sales_email_users}/${total_sales} ;;
    value_format_name: percent_2
  }

  measure: average_spend_per_user {
    description: "Total Sales per User"
    type: number
    sql: ${total_sales}/nullif(${users.count}, 0) ;;
    value_format_name: usd
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
