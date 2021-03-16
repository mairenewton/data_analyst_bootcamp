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

  dimension: age_tier {
    type: tier
    tiers: [18,25,50]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [city, state, country]
  }

  dimension: city_state {
    type: string
    sql: ${city}|| ', ' || ${state} ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;

    drill_fields: [city, state, country]
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      week_of_year,
      week,
      month,
      month_name,
      quarter,
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_raw}, CURRENT_DATE) ;;
  }

  dimension_group: since_signup_2 {
    type: duration
    sql_start: ${created_date} ;;
    sql_end: CURRENT_DATE ;;
    intervals: [day, week, month]
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    style: integer
    tiers: [5,50,90,150]
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
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

    drill_fields: [city, state, country]
  }

  dimension: is_email {
    type: yesno
    sql: UPPER(${traffic_source}) = 'EMAIL';;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count_cities {
    type: count_distinct
    sql: ${city_state} ;;
  }

  measure: is_new_user {
    type: count
    filters: [is_new_customer: "Yes"]
  }

  measure: usa_users {
    type: count
    filters: [country: "USA"]
  }

  measure: count_of_female_users {
    type: count
    filters: [gender: "Female"]
  }

  measure: pct_of_female_users {
    label: "Percent of Female Users"
    description: "Count of Female Users/Total Users"
    type: number
    sql: 1.0*${count_of_female_users}/${count_users} ;;
    value_format_name: percent_1
  }

  measure: count_users {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
