view: user_order_fact {
  derived_table: {
    sql: select
      users.id,
      sum(sale_price) as lifetime_revenue,
      count(distinct order_id) as lifetime_orders,
      min(order_items.created_at) as first_order,
      max(order_items.created_at) as last_order
      from users
      left join order_items on users.id = order_items.user_id
      group by 1
       ;;

  datagroup_trigger: users_etl
  sortkeys: ["id"]
  distribution: "id"
}

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
  }

  set: detail {
    fields: [id, lifetime_revenue, lifetime_orders, first_order_time, last_order_time]
  }
}
