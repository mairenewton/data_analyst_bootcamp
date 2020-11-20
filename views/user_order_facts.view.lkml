view: user_order_facts {
  derived_table: {
    sql: SELECT order_id
      , user_id
      , COUNT(*) AS count_of_items
      , SUM(sale_price) as total_sales
      FROM order_items
      GROUP BY 1, 2
       ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${order_id} || '_' || ${user_id} ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: items_per_order {
    type: number
    sql: ${TABLE}.count_of_items ;;
  }

  dimension: sales_per_order {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  measure: avg_sales_per_order {
    type: average
    sql: ${items_per_order} ;;
  }

  measure: avg_items_per_order {
    type: average
    sql: ${sales_per_order} ;;
  }

  set: detail {
    fields: [order_id, user_id, items_per_order, sales_per_order]
  }
}
