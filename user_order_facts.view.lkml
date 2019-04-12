view: sql_runner_query {
  derived_table: {
    sql: select
      user_id,
      min(created_at) as "user_first_order",
      max(created_at) as "user_last_order",
      count(distinct order_id) as "user_liftetime_orders",
      count(*) as "user_limetime_items"
      from order_items
      group by user_id
       ;;
  }

  measure: count {
    type: count
  }

  dimension: user_id {
    primary_key:  yes
    hidden:  yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: user_first_order {
    type: time
    timeframes: [ raw,date,week,month,year]
    sql: ${TABLE}.user_first_order ;;
  }

  dimension_group: user_last_order {
    type: time
    timeframes: [ raw,date,week,month,year]
    sql: ${TABLE}.user_last_order ;;
  }

  dimension: user_liftetime_orders {
    type: number
    sql: ${TABLE}.user_liftetime_orders ;;
  }

  dimension: user_limetime_items {
    type: number
    sql: ${TABLE}.user_limetime_items ;;
  }

  measure: average_user_lifetime_revenue {
    type:  average
    sql:  $(user_limetime_revenue}
  type: gbp
  ;;
  }


}
