view: user_order_facts {
  derived_table: {
    sql: SELECT
      user_id as user_id,
      sum(sale_price) as total_user_spend,
      min(created_at) as first_order_date,
      max(created_at) as last_order_date,
      Count(DISTINCT order_id) as total_user_orders,
      Count(*) as total_user_items

      FROM order_items

      where {% condition order_items.created_date %} created_at {% endcondition %}

      Group BY 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
  }

  dimension: total_user_spend {
    type: number
    sql: ${TABLE}.total_user_spend ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,date,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [
      raw,date,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: total_user_orders {
    type: number
    sql: ${TABLE}.total_user_orders ;;
  }

  dimension: total_user_items {
    type: number
    sql: ${TABLE}.total_user_items ;;
  }

  dimension: days_to_first_order {
    type: duration_day
    sql_start: ${users.created_raw} ;;
    sql_end: ${first_order_raw} ;;
  }

  measure: average_total_user_spend {
    description: "This calculates what is the average lifetime spend fo all users"
    type: average
    sql: ${total_user_spend} ;;
    value_format_name: usd
  }

  measure: average_total_user_order {
    description: "This calculates how many orders on average the users make in their"
    type: average
    sql: ${total_user_orders} ;;
    value_format_name: decimal_2
  }

  measure: average_total_user_items {
    type: average
    sql: ${total_user_items} ;;
    value_format_name: decimal_2
  }

  measure: average_user_days_to_first_order {
    type: average
    sql: ${days_to_first_order} ;;
    value_format_name: decimal_2
  }



  set: detail {
    fields: [
      user_id,
      total_user_spend,
      first_order_date,
      last_order_date,
      total_user_orders,
      total_user_items
    ]
  }
}
