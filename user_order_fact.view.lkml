view: user_order_fact {
  derived_table: {
    sql: SELECT
        users.id  AS "users.id",
        COUNT DISTINCT (order.id ) AS "order_id.count",
        MIN (order_id.created.at) AS first_order_date
        MAX (order_id.created.at) AS last_order_date
      FROM public.users  AS users
   LEFT JOIN public.order_items  AS order_id ON users.id = order_id.user_id
  Group by 1;;}


  measure: lifetime_revenue {
    type: sum
    sql: ${TABLE}."order_id.total_sales" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}."users.id" ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_id.count" ;;
  }

  set: detail {
    fields: [users_id, order_items_count]
  }
}
