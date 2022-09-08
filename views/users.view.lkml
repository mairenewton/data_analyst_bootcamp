include: "geography_dimensions.view"


view: users {
  extends: [geography_dimensions]
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

  # dimension: city {
  #   group_label: "Location"
  #   type: string
  #   sql: ${TABLE}.city ;;
  # }

  # dimension: country {
  #   group_label: "Location"
  #   type: string
  #   map_layer_name: countries
  #   sql: ${TABLE}.country ;;
  # }

  dimension_group: created {
    type: time
    timeframes: [
      raw,

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

  # dimension: days_since_signup {
  #   type: number
  #   sql: DATEDIFF(day, ${created_date}, current_date) ;;
  # }


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

  dimension: city_state {
    group_label: "Location"
    type: string
    sql: ${city} || ' - ' || ${state} ;;
  }

  dimension: age_group {
    type: tier
    tiers: [18, 25, 40, 55, 70]
    sql: ${age} ;;
    style: integer
  }

  dimension: is_traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }





  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_female_users {
    description: "Count of users that are female"
    type: count
    filters: [gender: "Female"]

  }


  measure: percent_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}/NULLIF(${count},0) ;;
  }





}
