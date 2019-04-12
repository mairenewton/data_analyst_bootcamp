view: user_order_facts {
  derived_table: {
    sql: select user_id
        ,min(created_at) as "user_first_order"
        ,max(created_at) as "user_last_order"
        ,sum(sale_price) as "user_lifetime_revenue"
        ,count(distinct order_id) as "user_lifetime_orders"
        ,count(*) as "user_lifetime_items"

      from order_items

      group by user_id
       ;;
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: user_first_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.user_first_order ;;
  }

  dimension_group: user_last_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.user_last_order ;;
  }

  dimension: user_lifetime_revenue {
    type: number
    sql: ${TABLE}.user_lifetime_revenue ;;
  }

  dimension: user_lifetime_orders {
    type: number
    sql: ${TABLE}.user_lifetime_orders ;;
  }

  dimension: user_lifetime_items {
    type: number
    sql: ${TABLE}.user_lifetime_items ;;
  }

  measure: average_user_lifetime_revenue {
    type: average
    sql: ${user_lifetime_revenue};;
  }

}
