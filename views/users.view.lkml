view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    group_label: "Basic Information"
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
      raw, # useful for join functions
      time,
      date, # "2020-05-18"
      week,
      month,
      quarter,
      day_of_month,
      month_name,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: mail {
    type: yesno
    sql: ${traffic_source} = 'Email';;
  }

  dimension: location {
    type: string
    sql: ${city} || ' ' || ${state} ;;
  }


  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

  dimension: is_new_customer {
    description: "This is users who signed up in  the past 90 days"
    type: yesno
    sql:  ${days_since_signup} <= 90 ;;
  }

  dimension: age_tier {
    group_label: "Basic Information"
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age} ;;
    style: integer
  }

  dimension: days_since_signup_tier {
    type: tier
    tiers: [0, 7, 14, 30, 90, 180, 360, 720]
    sql: ${days_since_signup} ;;
    style: integer # without the output is not pretty
  }

  dimension: email {
    group_label: "Basic Information"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    group_label: "Basic Information"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    group_label: "Basic Information"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    group_label: "Basic Information"
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
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count_female_users {
    type: count
    filters: [gender: "Female"]
  }

  measure: pc_female_users {
    label: "% Female Users"
    type: number
    sql:1.0 * ${count_female_users}/NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
