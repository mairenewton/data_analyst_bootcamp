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

  dimension_group: shipping_days {
    type: duration
    intervals: [day]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;

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


  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: total_sales_dp {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: avg_sales{
    type: average
    sql: ${sale_price} ;;
  }

  measure: avg_price_by_order {
    type: number
    sql: 1.0 * ${total_sales_dp}/nullif(${count_orders},0) ;;
  }


  dimension: user_is_email {
    type: yesno
    sql: ${users.is_email} ;;
  }

  measure: email_sales {
    type: sum
    sql: ${sale_price};;
    filters: {
      field: user_is_email
      value: "yes"
    }
  }

  measure: email_sale_count {
    type: count_distinct
    sql: ${order_id};;
    filters: {
      field: user_is_email
      value: "yes"
    }
  }
  measure: percent_email_count {
    type: number
    value_format_name: percent_0
    sql: ${email_sale_count}/nullif(${user_count},0) ;;
  }

  measure: percent_email {
    type: number
    value_format_name: percent_0
    sql: ${email_sales}/nullif(${total_sales},0) ;;
  }

  measure: user_count {
    type: number
    sql: ${users.count} ;;
  }
  measure: avg_sale_per_user {
    type: number
    value_format_name: usd
    sql: ${total_sales}/nullif(${user_count},0) ;;
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
