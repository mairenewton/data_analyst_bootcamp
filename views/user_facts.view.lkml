view: user_facts {
  derived_table: {
    sql: SELECT
      order_items.user_id as user_id

      ,COUNT(distinct order_items.order_id) as lifetime_order_count
      ,SUM(order_items.sale_price) as lifetime_revenue ,MIN(order_items.created_at) as first_order_date ,MAX(order_items.created_at) as latest_order_date
      FROM order_items GROUP BY user_id
       ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
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

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
