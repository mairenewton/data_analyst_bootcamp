
view: users_facts {
  derived_table: {
    sql: select
      order_items.user_id as user_id,
      count(distinct order_items.order_id) as lifetime_order_count,
      sum(order_items.sale_price) as lifetime_revenue
      from
      order_items
      group by user_id
       ;;
  }

measure: average_lifetime_order_count {
  type: average
  sql: ${lifetime_order_count} ;;

}

measure: average_lifetime_value {
  type: average
  sql: ${lifetime_revenue} ;;

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
