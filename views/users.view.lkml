

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
    group_label: "Location"

    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Location"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state, city]
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

  dimension: full_name {
    type: string
    sql: initcap(${first_name}) || ' ' || initcap(${last_name}) ;;
  }



  dimension_group: since_signup {
    description: "Grouping for duration since user created date"
    type: duration
    intervals: [day, week, month, quarter, year]
    sql_start: ${created_date} ;;
    sql_end: current_date ;;
  }


  dimension: is_new_customer {
    description: "If customer signed up in the last 90 days, yes new customer"
    label: "Is New Customer"
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }


  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [0, 30, 90, 180, 360, 720]
    style: integer
  }

  dimension: age_group {
    type: tier
    sql: ${age} ;;
    tiers: [0,18, 30, 60]
    style: integer
  }


  dimension: latitude {
    group_label: "Location"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Location"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    group_label: "Location"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: is_traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }


  dimension: zip {
    group_label: "Location"
    type: zipcode
    sql: ${TABLE}.zip ;;

  }

  measure: count_user {
    type: count
    description: "No. users"
    drill_fields: [user_location_details*]
  }

  measure: count_female_users {
    description: "Count of users that are female"
    type: count
    filters: [gender: "Female"]
    drill_fields: [user_location_details*]
  }

set: user_location_details {
  fields: [id, city, state, country]
}



  measure: percent_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}/NULLIF(${count_user},0) ;;
  }



}
