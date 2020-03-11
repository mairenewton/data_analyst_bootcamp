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
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age} ;;
    style: integer
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_state {
    type: string
    sql: ${city} || ', ' || ${state};;
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

#   dimension: days_since_signup {
#     type: number
#     sql: DATEDIFF(day, ${created_date}, current_date) ;;
#     }

  dimension_group: days_since_signup {
    type: duration
    intervals:
    [second, minute, hour,
      day, week,
      month, quarter, year]
    sql_start: ${TABLE}.created_date ;;
    sql_end: current_date() ;;
  }

#   dimension: days_since_signup_tier {
#     type: tier
#     tiers: [0, 30, 90, 180, 360, 720]
#     sql: ${days_since_signup} ;;
#     style: integer
#   }

dimension: is_new_user {
  type: yesno
  sql: ${days_days_since_signup} <= 90 ;;
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

  measure: count_distinct_first_names {
    type: count_distinct
    sql: ${first_name} ;;
  }

  measure: count_female_users {
    type: count
    filters:  {
      field: gender
      value: "Female"
    }
  }

  measure: percentage_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}
      /NULLIF(${count}, 0) ;;
  }


  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
