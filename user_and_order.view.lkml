explore:  user_and_order{}

view: user_and_order {
  derived_table: {
    sql: SELECT user_id
      , count (distinct order_id) as life_time_order_count
      , sum (sale_price) as life_time_revenue
      , min (created_at) as first_order_date
      , max (created_at) as last_order_date
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
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: life_time_order_count {
    type: number
    sql: ${TABLE}.life_time_order_count ;;
  }

  dimension: life_time_revenue {
    type: number
    sql: ${TABLE}.life_time_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order_date {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [user_id, life_time_order_count, life_time_revenue, first_order_date_time, last_order_date_time]
  }

  measure: avarage_life_time_order{
    type: average
    sql: ${life_time_order_count} ;;
  }
}
