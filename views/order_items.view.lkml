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

  dimension: profit {
    type:  number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type:  sum
    sql:${sale_price} ;;
    value_format_name: usd_0
  }

  measure: total_profit {
    type:  sum
    sql:${profit} ;;
    value_format_name: usd_0
  }
  measure: total_revenue_new_users {
    type:  sum
    sql: ${sale_price};;
    filters: [
      users.is_new_customer: "Yes"
    ]
    value_format_name: usd_0
  }

  measure: count_of_orders {
    type:  count_distinct
    sql: ${order_id} ;;
  }

  measure: count_of_complete_orders {
    type:  count_distinct
    sql: ${order_id} ;;
    filters: [status: "Complete",returned_date: "NULL"]
  }


  measure: total_revenue_from_email {
    type:  sum
    sql: ${sale_price} ;;
    filters: [
      users.traffic_source: "Email"]
    value_format_name: usd_0
  }

  measure: pct_revenue_traffic_source_email {
    type: number
    sql: 1.00*${total_revenue_from_email}/nullif(${total_revenue},0) ;;
    value_format_name: percent_1
  }

  measure: pct_complete_orders {
    type: number
    sql: 1.00*${count_of_complete_orders}/nullif(${count_of_orders},0) ;;
    value_format_name: percent_1
  }

  measure: average_spend_per_user {
    type: number
    sql: 1.0 * ${total_revenue} / nullif(${users.count_of_users},0) ;;
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
