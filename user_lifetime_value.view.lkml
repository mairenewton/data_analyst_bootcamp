view: user_lifetime_value {
  derived_table: {
    sql: select
      a.user_id,
      sum(a.sale_price) as lifetime_user_revenue,
      count(distinct a.order_id) as lifetime_user_order_count,
      MIN(a.created_at) AS first_order_date,
      MAX(a.created_at) AS latest_order_date
      from public.order_items as a
      group by 1
      order by 1
       ;;
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_user_revenue {
    type: number
    sql: ${TABLE}.lifetime_user_revenue ;;
  }

  dimension: lifetime_user_order_count {
    type: number
    sql: ${TABLE}.lifetime_user_order_count ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: avg_lifetime_order_count {
    type: average
    sql: ${lifetime_user_order_count} ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_user_revenue} ;;
  }

  set: detail {
    fields: [user_id, lifetime_user_revenue, lifetime_user_order_count, first_order_date_time, latest_order_date_time]
  }
}
