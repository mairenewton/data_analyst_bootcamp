
view: user_facts {
  derived_table: {
    sql: select
          order_id,
          user_id,
          count(distinct order_items.order_id) as order_count,
          sum(order_items.sale_price) as order_value
        from order_items
        group by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: order_value {
    type: number
    sql: ${TABLE}.order_value ;;
  }

  set: detail {
    fields: [order_id, user_id, order_count, order_value]
  }
}
