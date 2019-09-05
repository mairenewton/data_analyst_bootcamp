view: user_order_fact {
  derived_table: {
    datagroup_trigger: max_created_at
    distribution: "user_id"

    sql:
     select
       user_id,
       count(distinct order_id) as lifetime_order_count,
       sum(sale_price) as lifetime_revenue,
       min(created_at) as first_order_date,
       max(created_at) as latest_order_date
     from order_items
     where
     {% condition order_items.status %} ${order_items.status} % endcondition %} AND
     {% condition order_items.created_date %} ${order_items.created_date} {% endcondition %} AND
     {% condition user_order_fact.user_name %} ${order_items.user_name} {% endcondition %}
     group by user_id
      ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: customer_loyalty_tier {
    type: tier
    sql: ${lifetime_order_count} ;;
    tiers: [0,10,25,50]
  }
  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }
  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
    value_format_name: usd
  }
  dimension_group: first_order {
    type: time
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.first_order_date ;;
  }
  dimension_group: latest_order {
    type: time
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension_group: since_first_order{
    type: duration
    sql_start: ${first_order_raw} ;;
    sql_end: ${order_items.created_raw} ;;
  }


  dimension_group: first_order_month_cohort {
    type: time
    timeframes: [date, week, month, year]
    sql: ${first_order_raw} ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_time, latest_order_time]
  }
}
