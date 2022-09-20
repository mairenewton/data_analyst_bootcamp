view: user_facts {
  derived_table: {
    sql: SELECT user_id
      , COUNT(distinct order_id) as lifetime_order_count
      , SUM(sale_price) as lifetime_revenue

      FROM order_items
      GROUP BY user_id
      ;;
  }


  dimension: user_id {
    type: number
    primary_key: yes
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

  measure: avg_lifetime_order_count {
    description: "Average of count of orders by customers"
    label: "Average Lifetime Order Count"
    type: average
    sql: ${lifetime_order_count} ;;
  }


  measure: avg_lifetime_revenue {
    description: "Average of revenue per customer"
    label: "Average Lifetime Revenue"
    type: average
    sql: ${lifetime_revenue} ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
