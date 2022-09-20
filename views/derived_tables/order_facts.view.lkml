explore: order_facts {}

view: order_facts {
  derived_table: {
    sql: SELECT order_id
      , user_id
      , COUNT(*) AS item_count
      , SUM(order_items.sale_price) AS lifetime_revenue
FROM order_items
GROUP BY order_id, user_id
 ;;
  }


  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    primary_key: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: "usd"
  }

  set: detail {
    fields: [order_id, user_id, item_count, lifetime_revenue]
  }
}
