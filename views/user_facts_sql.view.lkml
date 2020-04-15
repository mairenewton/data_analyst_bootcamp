view: user_facts_sql {

  derived_table: {
    sql: SELECT
        user_id
        , COUNT(distinct order_id) as lifetime_orders
        , SUM(sales_price) as lifetime_order_amount
        , MAX(orders.created_at) as most_recent_purchase_at
      FROM orders
      GROUP BY user_id
      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    description: "Unique ID for each user that has ordered"
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_order_amount {
    description: "The total number of orders for each user"
    type: number
    sql: ${TABLE}.lifetime_order_amount ;;
  }

  dimension_group: most_recent_purchase {
    description: "The date when each user last ordered"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.most_recent_purchase_at ;;
  }

  measure: total_lifetime_orders {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${lifetime_orders} ;;
  }

  measure: total_lifetime_order_amount {
    type: sum
    sql: ${lifetime_order_amount} ;;
  }
}
