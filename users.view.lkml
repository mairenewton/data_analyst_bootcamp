view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    group_label: "PII"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    group_label: "Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Location"
    map_layer_name: countries
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
    group_label: "PII"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    group_label: "PII"
    type: string
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: full_name {
    group_label: "PII"
    type: string
    sql: (${first_name}||' '||${last_name});;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff('day',${created_date}, current_date );;
  }

  dimension: is_new_user{
    description: "Who has signed up in the last 90 days"
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: tier{
    type: tier
    sql: ${days_since_signup};;
    tiers: [
      30, 60, 90, 180
    ]
    style: integer
  }

  dimension: city_state {
    group_label: "Location"
    type: string
    sql: ${state}||'-'||${city} ;;
  }

  dimension: gender {
    group_label: "PII"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: location {
    group_label: "Location"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: last_name {
    group_label: "PII"
    type: string
    sql: INITCAP(${TABLE}.last_name );;
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
    map_layer_name: us_states
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city,zip]
  }

  dimension: age_group {
    group_label: "PII"
    type: tier
    sql: ${age};;
    tiers: [
      18,25,35,45,55,65,75,90
    ]
    style: integer
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    group_label: "Location"
    map_layer_name: us_zipcode_tabulation_areas
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [user_detail*]
  }

  measure: count_females {
    type: count
    filters: {
      field: gender
      value: "Female"
    }
    drill_fields: [user_detail*]
  }

  measure: woman_percentage {
    type: number
    sql: ${count_females}::DECIMAL(12,2)/nullif(${count},0)  ;;
    value_format_name: percent_0
  }


  set: user_detail {
    fields: [id, first_name, last_name, events.count]
  }

}
