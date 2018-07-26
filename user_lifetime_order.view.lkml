view: user_lifetime_order {
  derived_table: {
    sql: SELECT
        order_items.id  AS "order_items.id",
        COUNT(order_items.id ) AS "order_items.count"
      FROM public.users  AS users
      LEFT JOIN public.order_items  AS order_items ON users.id = order_items.user_id

      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_id {
    type: number
    sql: ${TABLE}."order_items.id" ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_items.count" ;;
  }

  set: detail {
    fields: [order_items_id, order_items_count]
  }
}
