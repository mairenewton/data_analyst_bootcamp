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

  dimension: age_group {
    type: tier
    sql: ${age} ;;
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    style: integer
  }

  dimension: city_and_state {
    label: " City and State"
    group_label: "Geographic Dimensions"
    type: string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: city {
    label: "City"
    group_label: "Geographic Dimensions"
    type: string
    sql: ${TABLE}.city ;;
    drill_fields: [zip]
  }

  dimension: country {
    label: "  Country"
    group_label: "Geographic Dimensions"
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name};;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: UPPER(${TABLE}.first_name) ;;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff('day', ${created_date}, current_date) ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [30, 60, 90, 180, 360, 720, 1000]
    style: integer
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: LOWER(${TABLE}.last_name) ;;
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
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: state {
    group_label: "Geographic Dimensions"
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    drill_fields: [city, zip]
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: zip {
    group_label: "Geographic Dimensions"
    type: zipcode
    sql: ${TABLE}.zip ;;
    map_layer_name: us_zipcode_tabulation_areas
  }

  measure: count {
    type: count
    drill_fields: [geography_details*]
  }

  measure: count_distinct_users {
    type: count_distinct
    sql: ${id} ;;
  }


  measure: count_male_users {
    type: count
    drill_fields: [geography_details*]
    filters: {
      field: gender
      value: "Male"
    }
  }

  measure: percent_male_users {
    type: number
    sql: (1.0*${count_male_users})/nullif(${count}, 0) ;;
    value_format_name: percent_2
  }


  set: geography_details {
    fields: [state, city, zip, count]
  }

  set: more_detailed_geo_details {
    fields: [geography_details*, location, longitude, latitude]
  }
}
