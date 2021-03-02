view: test_dt {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "order_items.user_id",
        COUNT(DISTINCT order_items.order_id) AS "order_items.order_count",
        SUM(order_items.sale_price ) AS "order_items.total_sales",
        MIN(order_items.created_at) as first_order_date,
        MAX(order_items.created_at) as last_order_date
      FROM order_items

      GROUP BY user_id
      LIMIT 100
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

  dimension: order_items_order_count {
    type: number
    sql: ${TABLE}."order_items.order_count" ;;
  }

  dimension: order_items_total_sales {
    type: number
    sql: ${TABLE}."order_items.total_sales" ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [order_items_user_id, order_items_order_count, order_items_total_sales, first_order_date_time, last_order_date_time]
  }
}
