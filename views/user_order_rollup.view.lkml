view: user_order_rollup {
  derived_table: {
    datagroup_trigger: orders_items_datagroup
    distribution_style: all
    sql: SELECT
        user_id  AS "user_id",
        COUNT(DISTINCT order_items.order_id ) AS "lifetime_order_count",
        MIN(DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', order_items.created_at ))) AS "first_order_date",
        MAX(DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', order_items.created_at ))) AS "last_order_date",
        COALESCE(SUM(order_items.sale_price ), 0) AS "lifetime_revenue"
      FROM public.order_items  AS order_items
      GROUP BY 1
      ORDER BY 1 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.users_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: last_order_date {
    type: date
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, first_order_date, last_order_date, lifetime_revenue]
  }
}
