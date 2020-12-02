view: user_fact {
  derived_table: {
    sql: SELECT
        users.state  AS "users.state",
        COUNT(DISTINCT order_items.order_id ) AS "order_items.order_count",
        COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(inventory_items.cost ,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CAST(inventory_items.id  AS VARCHAR)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CAST(inventory_items.id  AS VARCHAR)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CAST(inventory_items.id  AS VARCHAR)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CAST(inventory_items.id  AS VARCHAR)),15),16) AS DECIMAL(38,0))) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) AS "inventory_items.total_cost",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_revenue"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id
      LEFT JOIN public.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id

      GROUP BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_state {
    type: string
    sql: ${TABLE}."users.state" ;;
  }

  dimension: order_items_order_count {
    type: number
    sql: ${TABLE}."order_items.order_count" ;;
  }

  dimension: inventory_items_total_cost {
    type: number
    sql: ${TABLE}."inventory_items.total_cost" ;;
  }

  dimension: order_items_total_revenue {
    type: number
    sql: ${TABLE}."order_items.total_revenue" ;;
  }

  set: detail {
    fields: [users_state, order_items_order_count, inventory_items_total_cost, order_items_total_revenue]
  }
}
