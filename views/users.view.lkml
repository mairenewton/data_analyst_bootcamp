view: users {
  sql_table_name: public.users ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tiers {
    type: tier
    tiers: [18,25,45,60,90]
    sql: ${age} ;;
    style: integer
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
    description: "This is when a user signs up for an account."
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
    convert_tz: no
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

  dimension: is_traffic_email {
    type: yesno
    sql: lower(${traffic_source}) = lower('Email') ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: city_and_state {
    type: string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, CURRENT_DATE) ;;
  }

  dimension: is_new_customer {
    type: yesno
    description: "Customer signed up less than 90 days ago"
    sql: ${days_since_signup} <= 80 ;;
  }

  dimension: days_since_singup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [30,60,90,180]
    style: integer
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: latest_user_created {
    type: date
    sql: MAX(${created_date}) ;;
  }

  measure: count_female_users {
    type: count
    filters: [
      gender: "Female"
    ]
  }

  measure: count_of_new_users {
    type: count
    filters: [
      is_new_customer: "Yes"
    ]
  }

  measure: percentage_female_users {
    type: number
    sql: 1.0 * ${count_female_users} / NULLIF(${count},0) ;;
    value_format_name: percent_1
  }

}
