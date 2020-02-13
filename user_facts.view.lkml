view: user_facts {
  derived_table: {
##    datagroup_trigger: daily
##    distribution_style: all
##    sortkeys: [user_id]
    sql: Select user_id
          ,count(order_items.order_id) as lifetime_orders
          ,Sum(order_items.sale_price) as lifetime_revenue
          ,min(order_items.created_at) as first_order
          ,max(order_items.created_at) aslast_order

      From order_items
        Inner Join users
          On order_items.user_id = users.id

      Group By user_id

      limit 10
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

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: aslast_order {
    type: time
    sql: ${TABLE}.aslast_order ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_revenue, first_order_time, aslast_order_time]
  }

  measure: avg_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    value_format: "usd"
  }






}
