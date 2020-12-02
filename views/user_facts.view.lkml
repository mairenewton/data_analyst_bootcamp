view: user_facts {
  derived_table: {
    sql: SELECT order_items.user_id as user_id
      , users.state as state
      , COUNT (distinct order_items.order_id) as lifetime_order_count
      , SUM (order_items.sale_price) as lifetime_revenue
      , MIN (order_items.created_at) as first_order_date
      , MAX (order_items.created_at) as last_order_date
      FROM public.order_items order_items
      LEFT JOIN public.users users ON (users.id = order_items.user_id)
      GROUP BY user_id, state
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

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
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
    fields: [
      user_id,
      state,
      lifetime_order_count,
      lifetime_revenue,
      first_order_date_time,
      last_order_date_time
    ]
  }
}
