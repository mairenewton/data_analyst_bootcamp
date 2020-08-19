view: user_fact {
  derived_table: {
    sql: SELECT
          order_items.user_id  AS "user_id",
          SUM(order_items.sale_price)  AS "lifetime_spend",
          COUNT(DISTINCT order_items.order_id ) AS "lifetime_orders",
          COUNT(order_items.id ) AS "lifetime_items"
      FROM  public.order_items
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 5
       ;;
  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    hidden: yes
    primary_key: yes
  }

  dimension: lifetime_spend {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
    value_format: "usd"
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
    hidden: yes
  }

  dimension: lifetime_items {
    type: number
    sql: ${TABLE}.lifetime_items ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [user_id, lifetime_spend, lifetime_orders, lifetime_items]
  }
}
