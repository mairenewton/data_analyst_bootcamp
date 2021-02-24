view: user_facts {
  derived_table: {
    sql: SELECT
        u.id as user_id
      ,COUNT(distinct o.order_id) as lifetime_order_count
      ,SUM(o.sale_price) as lifetime_revenue
      ,MIN(o.created_at) as first_order_date
      ,MAX(o.created_at) as latest_order_date
      FROM users u
      left outer join order_items o on o.user_id = u.id
      group by 1
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  measure: avg_lifetime_value {
    type:  average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: avg_lifetime_order_count {
    type:  average
    sql: ${lifetime_order_count} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
