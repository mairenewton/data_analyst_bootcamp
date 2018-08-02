
view: user_order_facts {
  derived_table: {
    sql: SELECT
      user_id,
      min(created_at) as first_order_date,
      max(created_at) as last_order_date,
      sum(sale_price) as user_lifetime_value,
      count(distinct order_id) as user_lifetime_order,
      count(*) as user_lifetime_items
      FROM order_items
      GROUP BY user_id
       ;;
  }
  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
    hidden: yes
  }
  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.first_order_date ;;
  }
  dimension_group: last_order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.last_order_date ;;
  }
  dimension: user_lifetime_value {
    type: number
    sql: ${TABLE}.user_lifetime_value ;;
  }
  dimension: user_lifetime_order {
    type: number
    sql: ${TABLE}.user_lifetime_order ;;
  }
  dimension: user_lifetime_items {
    type: number
    sql: ${TABLE}.user_lifetime_items ;;
  }
  measure: average_lifetime_value {
    group_label: "All my metrics"
    type: average
    sql: ${user_lifetime_value} ;;
    value_format_name: eur
  }
}
