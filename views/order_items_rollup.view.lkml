view: order_items_rollup {
  derived_table: {
    sql: SELECT
        DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', order_items.created_at )) AS "order_items.created_date",
        order_items.status  AS "order_items.status",
        COUNT(DISTINCT order_items.order_id ) AS "order_items.count_of_orders",
        COUNT(DISTINCT users.id ) AS "users.count_of_users"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id

      GROUP BY 1,2
      ORDER BY 1 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_created_date {
    type: date
    sql: ${TABLE}."order_items.created_date" ;;
  }

  dimension: order_items_status {
    type: string
    sql: ${TABLE}."order_items.status" ;;
  }

  dimension: order_items_count_of_orders {
    type: number
    sql: ${TABLE}."order_items.count_of_orders" ;;
  }

  dimension: users_count_of_users {
    type: number
    sql: ${TABLE}."users.count_of_users" ;;
  }

  set: detail {
    fields: [order_items_created_date, order_items_status, order_items_count_of_orders, users_count_of_users]
  }
}
