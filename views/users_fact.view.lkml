view: users_fact {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "user_id",
        SUM(order_items.sale_price)  AS "lifetime_spend",
        COUNT(DISTINCT order_items.order_id ) AS "lifetime_orders",
        COUNT(order_items.id ) AS "lifetime_items"
      FROM  public.order_items
      GROUP BY 1


       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    hidden: yes
  }

  dimension: lifetime_spend {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_items {
    type: number
    sql: ${TABLE}.lifetime_items ;;
  }

  set: detail {
    fields: [user_id, lifetime_spend, lifetime_orders, lifetime_items]
  }
}
