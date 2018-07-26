view: aggregate_user_orders {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "order_items.user_id",
        COUNT(DISTINCT order_items.order_id ) AS "order_items.distinct_order_count",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_sales",
        MIN(order_items.created_At) AS "First Order Date",
        MAX(order_items.created_At) AS "Latest Order Date"
      FROM public.users  AS users
      LEFT JOIN public.order_items  AS order_items ON users.id = order_items.user_id

      GROUP BY 1
      ORDER BY 2 DESC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."order_items.user_id" ;;
  }

  dimension: order_items_distinct_order_count {
    type: number
    sql: ${TABLE}."order_items.distinct_order_count" ;;
  }

  dimension: order_items_total_sales {
    type: number
    sql: ${TABLE}."order_items.total_sales" ;;
  }

  dimension_group: first_order_date {
    type: time
    label: "first order date"
    sql: ${TABLE}."first order date" ;;
  }

  dimension_group: latest_order_date {
    type: time
    label: "latest order date"
    sql: ${TABLE}."latest order date" ;;
  }

  set: detail {
    fields: [order_items_user_id, order_items_distinct_order_count, order_items_total_sales, first_order_date_time, latest_order_date_time]
  }
}
