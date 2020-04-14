view: exercise_1 {
  derived_table: {
    sql: SELECT
      order_items.user_id AS user_id
      ,COUNT(distinct order_items.order_id) AS orders_over_lifetime
      ,SUM(order_items.sale_price) AS revenue_over_lifetime
      FROM order_items
      GROUP BY user_id
       ;;
  }

  measure: average_lifetime_sales {
    type: average
    sql: ${revenue_over_lifetime} ;;
    value_format: "$#.##"
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${orders_over_lifetime} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: orders_over_lifetime {
    type: number
    sql: ${TABLE}.orders_over_lifetime ;;
  }

  dimension: revenue_over_lifetime {
    type: number
    sql: ${TABLE}.revenue_over_lifetime ;;
  }

  set: detail {
    fields: [user_id, orders_over_lifetime, revenue_over_lifetime]
  }
}
