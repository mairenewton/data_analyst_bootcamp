view: customers {
  derived_table: {
    sql: select user_id, count(distinct order_id), sum(sale_price) lifetime_revenue, min(created_at) first_order_date, max(created_at) last_order_date from public.order_items group by user_id
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

  dimension: count_ {
    type: number
    sql: ${TABLE}.count ;;
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
    fields: [user_id, count_, lifetime_revenue, first_order_date_time, last_order_date_time]
  }
}
