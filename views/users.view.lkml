view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ', ' || ${last_name} ;;
  }

  dimension: age_tiered {
    type:  tier
    sql: ${age} ;;
    tiers: [10, 20, 30, 40, 60, 80]
    style: interval
  }

  dimension: is_email_traffic_source {
    type: yesno
    sql:  ${traffic_source} = 'Email' ;;
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
      month_name,
      quarter,
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: tenure_in_days {
    type: number
    sql: DATEDIFF(day, ${TABLE}.created_at, CURRENT_DATE) ;;
  }

  dimension: tenure_in_months {
    type: number
    sql: DATEDIFF(month, ${TABLE}.created_at, CURRENT_DATE) ;;
  }

  dimension: tenure_in_years {
    type: number
    sql: DATEDIFF(year, ${TABLE}.created_at, CURRENT_DATE) ;;
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

  dimension: location_lat_long {
    type: location
    sql_latitude:${latitude} ;;
    sql_longitude:${longitude} ;;
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
    description: "Count of users"
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: avg_age {
    type: average
    sql: ${age} ;;
    value_format_name: decimal_2
  }

  measure: unique_cities {
    type: count_distinct
    sql: ${city} ;;
  }

  measure: count_email_users {
    type: count
    filters: [
      traffic_source: "Email"
    ]
  }

  measure: percent_email_users {
    type: number
    sql: 1.00 * ${count_email_users}/${count} ;;
    value_format_name: percent_2
  }

  measure: count_female_users {
    type: count
    filters: [
      gender: "Female"
    ]
  }

  measure: percent_female_users {
    type: number
    sql: 1.00 * ${count_female_users}/${count} ;;
    value_format_name: percent_2
  }



}
