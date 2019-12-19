view: by_user_dt {
  derived_table: {
    sql: select users.id, count(distinct o.order_id) as count_orders, sum(o.sale_price) as total_revenue,
       min(o.created_at) as first_order, max(o.created_at) as last_order
          from users
          left join order_items o
          on users.id = o.user_id
          group by 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: count_orders {
    type: number
    sql: ${TABLE}.count_orders ;;
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
  }

  set: detail {
    fields: [id, count_orders, total_revenue, first_order_time, last_order_time]
  }

  measure: avg_orders {
    type: average
    sql: ${count_orders} ;;
  }
}
