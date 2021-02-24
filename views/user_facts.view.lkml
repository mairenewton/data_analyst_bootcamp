view: sql_runner_query {
  derived_table: {
    sql: SELECT
        users.id  AS "users.id",
        COUNT(DISTINCT order_items.order_id ) AS "order_items.total_orders",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_sales"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id

      WHERE order_items.status = 'Complete'
      GROUP BY 1
      ORDER BY 2 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}."users.id" ;;
  }

  dimension: order_items_total_orders {
    type: number
    sql: ${TABLE}."order_items.total_orders" ;;
  }

  dimension: order_items_total_sales {
    type: number
    sql: ${TABLE}."order_items.total_sales" ;;
  }

  measure: order_items_avg_orders {
    type: average
    sql: ${order_items_total_orders} ;;
    value_format_name: decimal_2
  }

  measure: order_items_avg_sales {
    type: average
    sql: ${order_items_total_sales} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [users_id, order_items_total_orders, order_items_total_sales]
  }
}
