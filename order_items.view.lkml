view: order_items {
  sql_table_name: public.order_items ;;


  dimension_group: since_users_first_order {
    type: duration
    sql_start: ${user_order_fact_ndt.first_order_raw} ;;
    sql_end: ${created_raw} ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    value_format_name: usd
    html: {{rendered_value}} ;;
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
    html: {{rendered_value}} ;;
  }

  filter: date_filter {
  type: date
}

  measure: min_order_created_date {
    hidden: yes
    type: date
    sql: min(${created_raw}) ;;
    html: {{rendered_value}} ;;
  }

  measure: max_order_created_date {
    type: date
    hidden: yes
    sql: max(${created_raw}) ;;
#     html: <a href={{rendered_value}}> ;;
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

  measure: count_orders {
    type: count_distinct
    sql: ${order_id} ;;
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
    required_access_grants: [finance]
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_revenue_from_email_channel {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: users.traffic_source
      value: "Email"
    }
  }

  measure: percent_revenue_from_email_source_users {
    type: number
    value_format_name: percent_0
    sql: 1.0*${total_revenue_from_email_channel}/nullif(${total_revenue},0) ;;
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd_0
    sql: ${total_revenue}/nullif(${users.count},0) ;;
  }

  measure: total_revenue {

    value_format_name: usd
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [shipped_date,status,count,total_revenue]
  }

  measure: total_revenue_new_users {
    type: sum
    sql: ${order_items.sale_price} ;;
    filters:  {
      field: users.is_new_user
      value: "Yes"
    }
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
    drill_fields: [id,
      users.id, users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name]
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
