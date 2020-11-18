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

dimension: days_to_ship {
  type: number
  sql:  DATEDIFF(day,${shipped_date}, ${delivered_date}) ;;
}
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
  }

measure: unique_orders {
  type: count_distinct
  sql: ${order_id} ;;
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
  measure: avg_spend_per_user {
    type: number
    value_format_name: usd
    sql:  1.0*${total_sales}/NULLIF(${users.count},0) ;;
  }
  measure: total_sales_email {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_src: "Yes"]

    value_format_name: usd
  }

  measure: percentage_email_users {
    type:  number
    sql: ${total_sales_email}/ ${total_sales} ;;
    value_format_name: percent_2
  }

  measure: avg_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
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
