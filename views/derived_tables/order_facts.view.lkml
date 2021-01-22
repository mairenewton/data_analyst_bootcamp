view: order_facts {
  derived_table: {
    sql: select order_items.order_id as order_id, count(*) as item_count, sum(order_items.sale_price) as lifetime_revenue
      from order_items
      group by order_id
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  set: detail {
    fields: [order_id, item_count, lifetime_revenue]
  }
}
