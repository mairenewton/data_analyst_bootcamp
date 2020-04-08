view: training1 {
    derived_table: {
      sql: SELECT
        users.id  AS "users_id",
        COUNT(DISTINCT order_items.id) AS "order_count",
        COALESCE(SUM(order_items.sale_price ), 0) AS "total_sales",
        MIN(order_items.created_at) AS "first_order",
        MAX(order_items.created_at) AS "last_order"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id
      GROUP BY 1
      ORDER BY 1 ,2 ,3 DESC
      LIMIT 500
       ;;
    }


    dimension: users_id {
      type: number
      sql: ${TABLE}."users_id" ;;
    }

    dimension: order_count {
      type: number
      sql: ${TABLE}."order_count" ;;
    }

    dimension: total_sales {
      type: number
      sql: ${TABLE}."total_sales" ;;
    }

    dimension: first_order {
      type: date
      sql: ${TABLE}."first_order" ;;
    }

    dimension: last_order {
      type: date
      sql: ${TABLE}."last_order" ;;
    }
    dimension: diff_between_last_first_date {
      type: number
      sql: datediff(d,${first_order},${last_order}) ;;
    }
    measure: average_order_count {
      type: average
      sql: ${TABLE}."order_count" ;;
    }

    measure: average_total_sales {
      type: average
      sql: ${TABLE}."total_sales" ;;
    }
    measure: average_diff_between_last_first_date {
      type: average
      sql: ${diff_between_last_first_date} ;;
    }
  dimension: average_days_between_orders {
    type: number
    sql: ${diff_between_last_first_date}/(${order_count}-1) ;;
  }



  }
