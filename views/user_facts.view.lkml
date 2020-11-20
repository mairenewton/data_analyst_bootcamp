view: user_facts {
  derived_table: {
    sql: SELECT user_id
      , SUM(sale_price) AS lifetime_sales
      , COUNT(DISTINCT order_id) AS lifetime_orders
      , MIN(created_at) AS date_of_first_order
      , MAX(created_at) AS date_of_last_order
      , SUM(CASE WHEN status = 'Complete' THEN sale_price ELSE NULL END) as lifetime_sales_from_complete_orders
      FROM order_items
      GROUP BY 1
       ;;
  }


  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: date_of_first_order {
    type: time
    sql: ${TABLE}.date_of_first_order ;;
  }

  dimension_group: date_of_last_order {
    type: time
    sql: ${TABLE}.date_of_last_order ;;
  }

  dimension: lifetime_sales_from_complete_orders {
    type: number
    sql: ${TABLE}.lifetime_sales_from_complete_orders ;;
  }

  measure: avg_lifetime_sales {
    type: average
    sql: ${lifetime_sales} ;;
  }

  measure: avg_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_sales,
      lifetime_orders,
      date_of_first_order_time,
      date_of_last_order_time,
      lifetime_sales_from_complete_orders
    ]
  }
}
