view: user_facts {
  derived_table: {
    sql: SELECT USER_ID,
        MIN(CREATED_AT) AS timestamp_first_order,
        MAX(CREATED_AT) AS timestamp_latest_order,
        COUNT(DISTINCT ID) AS customer_lifetime_orders,
        SUM(SALE_PRICE) AS customer_lifetime_revenue
        --COUNT(DISTINCT CASE WHEN STATUS='Complete' THEN ID ELSE NULL END) AS customer_lifetime_orders,
        --SUM(CASE WHEN STATUS='Complete' THEN SALE_PRICE ELSE 0 END) AS customer_lifetime_revenue
      FROM PUBLIC.ORDER_ITEMS
      WHERE {% condition filter_date %} CREATED_AT {% endcondition %}
      GROUP BY USER_ID
       ;;
  }

  filter: filter_date {
    type: date
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: timestamp_first_order {
    type: time
    sql: ${TABLE}.timestamp_first_order ;;
    timeframes: [time,date,week,month]
  }

  dimension_group: timestamp_latest_order {
    type: time
    sql: ${TABLE}.timestamp_latest_order ;;
    timeframes: [time,date,week,month]
  }

  dimension: customer_lifetime_orders {
    type: number
    sql: ${TABLE}.customer_lifetime_orders ;;
  }

  dimension: customer_lifetime_revenue {
    type: number
    sql: ${TABLE}.customer_lifetime_revenue ;;
  }

  measure: average_customer_lifetime_orders {
    type: average
    sql: 1.00*${customer_lifetime_orders} ;;
    value_format: "0.##"
    drill_fields: [detail*]
  }

  measure: average_customer_lifetime_revenue {
    type: average
    sql: ${customer_lifetime_revenue} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      user_id,
      timestamp_first_order_time,
      timestamp_latest_order_time,
      customer_lifetime_orders,
      customer_lifetime_revenue
    ]
  }
}
