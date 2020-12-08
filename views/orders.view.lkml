view: orders {
  derived_table: {
    sql: SELECT
        order_items.order_id AS order_id
        ,COUNT(*) AS item_count
        ,SUM(order_items.sale_price) AS order_total  --we might also be interested in average order total per age group
      FROM public.order_items
      GROUP BY order_id
       ;;
  }

  measure: order_count {
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

  dimension: order_total {
    type: number
    sql: ${TABLE}.order_total ;;
  }

  measure: average_items_per_order {
    type: average
    sql: ${item_count} ;;
  }

  set: detail {
    fields: [order_id, item_count, order_total]
  }
}
