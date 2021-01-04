view: customers_lifetime {
  derived_table: {
    sql: SELECT user_id,
                state,
      SUM(sale_price) AS sales_price_lifetime,
      COUNT(DISTINCT order_id) AS order_count_lifetime
      FROM order_items
      GROUP BY 1,2
       ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
    hidden: yes
  }

  dimension: state {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: sales_price_lifetime {
    type: number
    sql: ${TABLE}.sales_price_lifetime ;;
  }

  dimension: order_count_lifetime {
    type: number
    sql: ${TABLE}.order_count_lifetime ;;
  }

  measure: avg_lifetime_value {
    type: average
    sql: ${sales_price_lifetime} ;;
  }

  measure: avg_lifetime_order_count {
    type: average
    sql: ${order_count_lifetime} ;;
  }
}
