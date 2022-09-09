view: orders_and_sales_per_user {
  derived_table: {
    sql: select user_id, count (order_id) as numberoforders, sum (sale_price ) as salesSum from public.order_items
      group by user_id
       ;;
  }



  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: numberoforders {
    type: number
    sql: ${TABLE}.numberoforders ;;
  }

  dimension: salessum {
    type: number
    sql: ${TABLE}.salessum ;;
  }

measure: average_orders_lifetime {
  type: average
  sql: ${numberoforders} ;;
}
measure: average_sales_lifetime {
type: average
sql: ${salessum};;
}
}
