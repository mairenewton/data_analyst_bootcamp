view: user_fact {
  derived_table: {
    sql:  select
    user_id,count(distinct order_id) as lifetime_orders,
    sum(sale_price) as lifetime_rev,
    min(nullif(created_at,0)) as first_order,
    max(nullif(created_at,0)) as lastest_order
    from public.order_items
    group by user_id;;
  }

  # # Define your dimensions and measures here, like this:
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
}
