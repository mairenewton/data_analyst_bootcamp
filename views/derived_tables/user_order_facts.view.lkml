view: user_order_facts {
  derived_table: {
    sql: SELECT
      user_id,
      sum(sale_price) as user_lifetime_value,
      COUNT(*) as user_liftime_items,
      COUNT(DISTINCT order_id) as user_lifetime_orders,
      min(created_at) as first_order_dt,
      max(created_at) as last_order_dt
      from
      order_items

      WHERE
        {% condition order_items.created_date %} created_at {% endcondition %}

      GROUP BY 1
       ;;
  }



  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: user_lifetime_value {
    type: number
    sql: ${TABLE}.user_lifetime_value ;;
  }

  dimension: user_liftime_items {
    type: number
    sql: ${TABLE}.user_liftime_items ;;
  }

  dimension: user_lifetime_orders {
    type: number
    sql: ${TABLE}.user_lifetime_orders ;;
  }

  dimension_group: first_order_dt {
    type: time
    sql: ${TABLE}.first_order_dt ;;
  }

  dimension_group: last_order_dt {
    type: time
    sql: ${TABLE}.last_order_dt ;;
  }

  measure: average_user_lifetime_value {
    type: average
    sql: ${user_lifetime_value} ;;
    value_format_name: gbp
  }

}
