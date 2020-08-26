view: order_items_rollup {
  derived_table: {
    sql: SELECT
        DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', order_items.created_at )) AS "order_items.created_date",
        order_items.status  AS "order_items.status",
        COUNT(*) AS "order_items.count",
        COUNT(DISTINCT users.id ) AS "users.count"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id

      WHERE
        (order_items.created_at  < (CONVERT_TIMEZONE('America/New_York', 'UTC', DATEADD(day,0, DATE_TRUNC('day',CONVERT_TIMEZONE('UTC', 'America/New_York', GETDATE())) ))))
      GROUP BY 1,2
      ORDER BY 1 DESC
      LIMIT 500
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

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_items.count" ;;
  }

  dimension: users_count {
    type: number
    sql: ${TABLE}."users.count" ;;
  }

  set: detail {
    fields: [order_items_created_date, order_items_status, order_items_count, users_count]
  }
}
