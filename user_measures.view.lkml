view: user_measures {
  derived_table: {
    sql: SELECT
        users.id  AS "users_id",
        COUNT(*) AS "order_count",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_total_sales"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id
      GROUP BY 1
      ORDER BY 2 DESC
       ;;
  }


  dimension: users_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."users_id" ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_count" ;;
  }

  dimension: order_items_total_sales {
    type: number
    sql: ${TABLE}."order_total_sales" ;;
  }

  set: detail {
    fields: [users_id, order_items_count, order_items_total_sales]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: average_order_count {
    type: average
    sql: ${TABLE}."order_count" ;;
  }

  measure: average_order_total_sales {
    type: average
    sql: ${TABLE}."order_total_sales" ;;
  }


}
