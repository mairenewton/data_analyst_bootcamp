view: user_facts {
  derived_table: {
    sql: SELECT order_items.user_id,
        count(order_id) as lifetime_order_count,
        sum(sale_price) as lifetime_revenue

        FROM public.order_items
        GROUP BY user_id

       ;;
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
    hidden: yes
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
    description: "Average of number of orders placed in customer lifetime"
    type: average
    sql: ${lifetime_order_count}  ;;
  }

  measure: avg_lifetime_revenue {
    description: "Average of sale amount placed in customer lifetime"
    type: average
    sql: ${lifetime_revenue} ;;

  }


  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
