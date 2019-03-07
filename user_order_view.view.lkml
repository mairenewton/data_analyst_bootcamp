view: user_order_view {
  derived_table: {
    sql: SELECT user_id
        , COUNT(DISTINCT order_id) as lifetime_order_count
        , SUM(sale_price) as lifetime_revenue
        , MIN(created_at) as first_order_date
        , MAX(created_at) as last_order_date
      FROM public.order_items
      GROUP BY user_id
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

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, last_order_date_time]
  }
}
