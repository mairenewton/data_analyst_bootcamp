view: _dt_user_lifetime_order {
  derived_table: {
    sql: select o.user_id
      ,count(distinct o.order_id) as lifetime_order_count
      ,sum(o.sale_price) as lifetime_revenue
      ,min(o.created_at) as first_order_date
      ,max(o.created_at) as last_order_date
      from order_items o
      group by
      o.user_id

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
