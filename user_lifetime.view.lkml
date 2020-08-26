view: user_lifetime {
  derived_table: {
    sql: select user_id
      ,count(distinct order_items.id) as lifetime_order_cnt
      ,sum(order_items.sale_price) as lifetime_sales_amt
      ,min(order_items.created_at) as min_order_date
      ,max(order_items.created_at) as max_order_date
from order_items
group by 1
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_cnt {
    type: number
    sql: ${TABLE}.lifetime_order_cnt ;;
  }

  dimension: lifetime_sales_amt {
    type: number
    sql: ${TABLE}.lifetime_sales_amt ;;
  }

  dimension_group: min_order_date {
    type: time
    sql: ${TABLE}.min_order_date ;;
  }

  dimension_group: max_order_date {
    type: time
    sql: ${TABLE}.max_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_cnt, lifetime_sales_amt, min_order_date_time, max_order_date_time]
  }
}
