view: order_facts {
  derived_table: {
    sql: select order_id
      , sum(sale_price) as order_cost
      , count(*) as items_in_order
      from public.order_items
      group by order_id
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    hidden:  yes
  }

  dimension: order_cost {
    type: number
    sql: ${TABLE}.order_cost ;;
    hidden:  yes
  }

  dimension: items_in_order {
    type: number
    sql: ${TABLE}.items_in_order ;;
  }

  set: detail {
    fields: [order_id, order_cost, items_in_order]
  }
}
