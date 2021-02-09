view: user_facts {
  derived_table: {
    sql: SELECT
        user_id as user_id
      , COUNT(*) as lifetime_orders
      , MAX(created_at) as most_recent_purchase_at
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

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: most_recent_purchase_at {
    type: time
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, most_recent_purchase_at_time]
  }
}
