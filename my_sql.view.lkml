view: my_sql {
  derived_table: {
    sql: SELECT
        users.id  AS "users.id",
        COUNT(order_items.id ) AS "order_items.order_item_count",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_revenue",
        min(DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.created_at )))  as first_oreer_date,
          max(DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.created_at )))  as last_order_date
      FROM public.users  AS users
      LEFT JOIN public.order_items  AS order_items ON users.id = order_items.user_id

      GROUP BY 1

       ;;
  }



  dimension: users_id {
    type: number
    sql: ${TABLE}."users.id" ;;
  }

  dimension: order_items_order_item_count {
    type: number
    sql: ${TABLE}."order_items.order_item_count" ;;
  }

  dimension: order_items_total_revenue {
    type: number
    sql: ${TABLE}."order_items.total_revenue" ;;
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_oreer_date ;;
  }

  dimension: last_order_date {
    type: date
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [users_id, order_items_order_item_count, order_items_total_revenue, first_order_date, last_order_date]
  }
}
