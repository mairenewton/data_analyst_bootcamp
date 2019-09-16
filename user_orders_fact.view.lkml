view: user_orders_fact {
  derived_table: {
    sql: select  order_items.user_id as user_id,
        count(distinct order_items.order_id) as lifetime_order_count,
        sum(order_items.sale_price) as lifetime_revenue,
        min(order_items.created_at) as first_order_date,
        max(order_items.created_at) as last_order_date
from order_items
where
{% condition order_items.status %} order_items.status {% endcondition %}
AND
{% condition order_items.created_date %} order_items.created_at {% endcondition %}
AND
{% condition user_orders_fact.user_name %} user_orders_fact.user_name {% endcondition %}
group by user_id
 ;;
  }

  filter: user_name {
    type: string
    suggest_explore: order_items
    suggest_dimension: users.first_name
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

  dimension: order_count_bucket {
    type: tier
    sql: ${lifetime_order_count};;
    tiers: [0,10,20,50]
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_time, last_order_time]
  }
}
