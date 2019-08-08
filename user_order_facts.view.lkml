view: user_order_facts {
  derived_table: {
#     datagroup_trigger: new_item_identifier
    sql: select
      user_id as user_id,
      sum(sale_price) as total_user_spend,
      min(created_at) as first_order_date,
      max(created_at) as last_order_date,
      count(distinct order_id) as total_user_order,
      count(*) as total_user_items

      from order_items
      --Templated filter
        WHERE {% condition order_items.created_date %} created_at {% endcondition %}

      Group By 1
       ;;
  }
#       WHERE {% condition date %} created_at {% endcondition %}

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

filter: date {
  type: date
}

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_user_spend {
    type: number
    sql: ${TABLE}.total_user_spend ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: total_user_order {
    type: number
    sql: ${TABLE}.total_user_order ;;
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

  measure: avg_total_user_spend {
    type: average
    sql: ${total_user_spend} ;;
    value_format_name: usd
  }

  measure: avg_total_user_Orders {
    type: average
    sql: ${total_user_order} ;;
    value_format_name: decimal_2
  }

  measure: avg_total_user_items {
    type: average
    sql: ${total_user_items} ;;
    value_format_name: decimal_2
  }

  measure: avg_days_to_first_oder {
    type: average
    sql: ${days_to_first_order} ;;
    value_format_name: decimal_2
  }

#   set: detail {
#     fields: [
#       user_id,
#       total_user_spend,
#       first_order_date_time,
#       last_order_date_time,
#       total_user_order,
#       total_user_items
#     ]
#   }
}
