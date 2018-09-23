view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: city_state {
    type: string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: is_email_traffic {
    type: yesno
    sql: ${TABLE}.traffic_source = 'Email' ;;
  }

  dimension: age_brackets {
    type:  tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${TABLE}.age ;;
    style:  integer
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: total_email_sales {
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: {
      field: is_email_traffic
      value: "YES"
    }
  }

  measure: total_sales {
    type: sum
    sql: ${order_items.sale_price} ;;
  }

  measure: percentage_email_sales {
    type: number
    sql: ${total_email_sales} / NULLIF(${total_sales}, 0) ;;
  }

  measure: average_sales {
    type: number
    value_format_name: usd
    sql: ${total_sales} / NULLIF(${count}, 0) ;;
  }
}
