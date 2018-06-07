view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tiers {
    type: tier
    sql: ${age} ;;
    tiers: [18,25,35,45,55,65,75,90]
    style: integer
  }

  dimension: city {
    group_label: "User Location"
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: country {
    group_label: "User Location"
    type: string
    sql: ${TABLE}.country ;;
    map_layer_name: countries
  }

  dimension: city_state {
    group_label: "User Location"
    type: string
    sql: ${city} || ', ' || ${state} ;;
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
    convert_tz: no
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff('day', ${created_raw}, current_date) ;;
  }

  dimension: is_new_user {
    description: "A new user is anyone who has skigned up within the last 90 days"
    type: yesno
    sql: ${days_since_signup}<=90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [30, 60, 90, 180, 360, 720, 1000, 1500]
    style: integer
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: UPPER(${TABLE}.first_name) ;;
  }

  dimension: full_name {
    label: "Full Name"
    type: string
    sql: ${first_name} || ' ' || ${last_name}   ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: UPPER(${TABLE}.last_name) ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    group_label: "User Location"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    group_label: "User Location"
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city, zip]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: is_email_traffic {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: zip {
    group_label: "User Location"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [users_detail*]
  }






set: users_detail {
  fields: [created_date, state, city, zip, count]
}



}
