view: derived_example {
  derived_table: {
    sql: SELECT
        order_items.order_id AS order_id
        ,COUNT(*) AS item_count

        ,SUM(order_items.sale_price) AS lifetime_revenue  --we might also be interested in average order total per age group
      FROM order_items
      GROUP BY order_id
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
