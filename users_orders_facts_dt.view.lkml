view: users_orders_facts_dt {
  derived_table: {
    sql: select users.id as usersid,
    count(distinct(order_items.id)),
    sum(order_items.sale_price),
    min(order_items.created_at) as first_order,
    max(order_items.created_at) as latest_order
       from users inner join order_items on
       users.id=order_items.user_id
       group by users.id
       ;;
  }

  dimension: usersid {
    type: number
    sql: ${TABLE}.usersid ;;
  }

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  set: detail {
    fields: [usersid, count, lifetime_revenue, first_order_date, latest_order_date]
  }
}
