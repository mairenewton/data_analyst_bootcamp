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

  dimension: shipping_days {
    type:  number
    sql:  DATEDIFF(day, ${shipped_date},${delivered_date}) ;;
  }

  dimension: profit {
    type:  number
    value_format_name:  usd
    sql:  ${sale_price} - ${inventory_items.cost} ;;
  }

  measure: total_sales_email_users {
    type:  sum
    sql:  ${sale_price} ;;
    filters: {
      field: users.is_email_source
      value: "Yes"
    }
  }

  measure: percentage_sales_email_source {
    type:  number
    value_format_name:  percent_2
    sql:  1.0*$total_sales_email_users}/NULLIF(${total_sales},0) ;;
  }

  measure: average_spend_per_user {
    type:  number
    value_format_name:  usd
    sql:  1.0*${total_sales}/NULLIF(${users.count},0) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count {
    type: count_distinct
    sql: {order_id} ;;
  }

  measure: average_sales {
    type:  average
    sql:  ${sale_price};;
  }

  measure: total_sales {
    type:  sum
    sql:  ${sale_price};;
  }

  measure: total_sales_new_users {
    type:  sum
    sql:  ${sale_price} ;;
    filters: {
      field:  users.is_new_user
      value:  "Yes"
    }
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
