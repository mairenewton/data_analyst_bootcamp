view: order_items_lifetime_revenue {
  derived_table: {
    sql: select
      order_items.order_id,
      order_items.user_id,
      count(*) as item_count,
      sum(order_items.sale_price) as total_sales
      FROM public.order_items
      group by 1,2
      order by 1,2
      limit 10
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

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  set: detail {
    fields: [order_id, user_id, item_count, total_sales]
  }
}
