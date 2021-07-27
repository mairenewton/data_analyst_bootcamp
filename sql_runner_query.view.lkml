view: sql_runner_query {
  derived_table: {
    sql: select
      user_id,
      COUNT(DISTINCT order_id) as lifetime_orders,
      SUM(sale_price) as lifetime_revenue,
      MIN(NULLIF(created_at,0)) as first_order,
      MAX(NULLIF(created_at,0)) as last_order,
      COUNT(DISTINCT DATE_TRUNC('month', NULLIF(created_at,0))) as number_of_distinct_months_with_orders
      FROM
      order_items
      GROUP By user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_orders,
      lifetime_revenue,
      first_order_time,
      last_order_time,
      number_of_distinct_months_with_orders
    ]
  }
}
