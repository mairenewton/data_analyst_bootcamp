view: users_order_item_dt {
  derived_table: {
    sql: select
      user_id,
      count(distinct order_id) as lifetime_order_count,
      sum(sale_price) as lifetime_revenue,
      min(created_at) as first_order_date,
      max(created_at) as last_order_date
      from order_items
      group by 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  measure: avg_lifetime_users {
    type: average
    sql: ${lifetime_order_count} ;;
  }
  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, last_order_date_time]
  }
}