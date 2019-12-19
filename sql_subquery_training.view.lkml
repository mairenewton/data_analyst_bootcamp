view: sql_subquery_training {
  derived_table: {
    sql: select user_id,
        count(distinct order_id) as lifetime_order_count,
        sum(sale_price) as lifetime_sales,
        min(created_at) as first_order_date,
        max(created_at) as last_order_date
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key:  yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  measure: avg_lifetime_orders{
    type: average
    sql: ${lifetime_order_count} ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_sales, first_order_date_time, last_order_date_time]
  }
}
