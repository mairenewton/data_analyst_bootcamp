view: user_facts {
  derived_table: {
    sql: Select
      order_items.user_id as user_id,
      Count(distinct order_items.order_id) as Lifetime_Order_Count,
      sum(order_items.sale_price) as lifetime_revenue
      from order_items
      Group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
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

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue]
  }
}
explore: user_facts {}
