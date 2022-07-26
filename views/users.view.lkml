view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: fullname {
    type: string
    sql:  ${TABLE}.first_name || ' '  ||  ${TABLE}.last_name   ;;

  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
    value_format_name: decimal_2
  }

  dimension: age_tiered {
    type: tier
    sql: ${age} ;;
    tiers: [10, 20, 30, 40,60,80]
    style: interval

  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
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
      month_name,
      quarter,
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_ago_created {
    type: number
    sql: DATEDIFF(day, ${created_date}, GETDATE()) ;;
  }

  dimension_group: since_created {
    type: duration
    intervals: [
      day,
      week,
      month,
      year]
    sql_start: ${created_raw} ;;
    sql_end: GETDATE() ;;
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

  dimension: location {
    type: location
    sql_latitude: ${latitude};;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }


  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: avg_user_age {
    type: average
    sql: ${age} ;;

  }
  measure: cities {
    type: count_distinct
    sql: ${city} ;;
  }

  measure: email_acquired {
    type: count
    filters: [
      traffic_source: "Email"
    ]
  }
  measure: avg_time_since_signup {
    type:  number
    sql: sum ${days_ago_created} / ${count};;
  }

  measure: average_years_since_created {
    type: average
    sql: ${years_since_created} ;;
    value_format_name: decimal_2
  }
  measure: no_of_new_users {
    type: number
    sql: ${days_ago_created} <=30 ;;
  }

  measure: count_new_users {
    type: count
    filters: [
      created_date: "last 30 days"
    ]
  }
}
