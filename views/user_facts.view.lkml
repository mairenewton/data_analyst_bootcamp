view: user_facts {

  derived_table: {
    sql: SELECT user_id, count(order_id) count_order_id , sum(sale_price) sum_sale_price FROM public.order_items GROUP BY 1
      ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: count_order_id {
    type: number
    sql: ${TABLE}.count_order_id ;;
  }

  dimension: sum_sale_price {
    type: number
    sql: ${TABLE}.sum_sale_price ;;
  }

  measure: avg_order_id {
    type: average
    sql: ${count_order_id} ;;
  }

  measure: avg_sale_price {
    type: average
    sql: ${sum_sale_price} ;;
  }

}
