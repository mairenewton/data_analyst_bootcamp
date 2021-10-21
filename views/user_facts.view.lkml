view: user_facts {
  derived_table: {
    sql: select order_items.user_id,
      count(distinct order_items.order_id) as lifetime_order_count,
      sum(order_items.sale_price) as lifetime_revenue,
      min(order_items.created_at) as first_order_id,
      max(order_items.created_at) as last_order_id
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension_group: first_order_id {
    type: time
    sql: ${TABLE}.first_order_id ;;
  }

  dimension_group: last_order_id {
    type: time
    sql: ${TABLE}.last_order_id ;;
  }

  measure: average_lifetime_value {
    type: average
    sql: ${lifetime_revenue} ;;
  }


  measure: average_lifetime_order_count {
    type: average
    sql: ${lifetime_order_count} ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_id_time, last_order_id_time]
  }
}
