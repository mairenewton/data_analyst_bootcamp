view: user_dt {
  derived_table: {
    sql:
      SELECT u.id as user_id, count(distinct(oi.id)) as lifetime_order_count, sum(oi.sale_price) as lifetime_revenue, min(oi.created_at) as first_order_date, max(oi.created_at) as latest_order_date, u.state
      FROM users u
      LEFT JOIN order_items oi ON u.id = oi.user_id
      GROUP BY u.id, u.state;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_order_by_state {
    type: average
    sql: ${lifetime_order_count} ;;
  }

  dimension: user_id {
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

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_order_count,
      lifetime_revenue,
      first_order_date_time,
      latest_order_date_time,
      state
    ]
  }
}
