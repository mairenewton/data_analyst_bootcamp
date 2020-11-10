view: users {
  sql_table_name: public.users ;;

########### DIMENSION ######### {
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

  dimension: full_name {
    type: string
    sql:  ${first_name} || ${last_name} ;;
  }

  dimension: days_since_signup {
    type: number
    sql:  datediff(day, ${created_raw}, current_date) ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql:  ${days_since_signup} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type:  tier
    sql:  ${days_since_signup} ;;
    tiers: [0, 30, 60, 90, 120, 240, 360, 720]
    style: integer
  }

  dimension: city_state {
    label: "City, State"
    type: string
    sql:  ${city} || ', ' || ${state} ;;
  }

  dimension: age_tiers {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql:  ${age} ;;
    style:  integer
  }

  dimension: email_source {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  ############ END DIMENSIONS ##########}

########### MEASURES ##########{

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_of_female_users {
    type: count
    filters: [gender: "Female"]
  }

  measure: percent_of_female_users {
    type: number
    sql: 1.0*${count_of_female_users}/${count};;
    value_format_name: percent_1
  }
}

########### END MEASURES #########}
