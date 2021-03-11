view: user_facts {
  derived_table: {
    sql: SELECT
         order_items.user_id AS user_id
        ,COUNT(distinct order_items.order_id) AS lifetime_order_count
        ,SUM(order_items.sale_price) AS lifetime_revenue
      FROM order_items
      GROUP BY user_id
       ;;
  }


  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_order_count} ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
  }



  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
