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

  dimension: name {
    label: "Name"
    type: string
    sql: ${first_name}||' '||${last_name};;
  }

dimension: days_since_signup {
  type: number
  sql: datedif(day, ${created_date}, current_date) ;;
}

dimension: days_since_signup_v2 {
  type: duration_day
  sql_start: ${created_date};;
  sql_end: current_date;;
}

dimension: is_new_user {
  type: yesno
  sql: ${days_since_signup} < 90;;
}

dimension: days_since_signup_bucket {
  type: tier
  tiers: [20, 40, 60, 90, 120]
  sql: ${days_since_signup} ;;
  style: integer
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

  dimension: city_and_state {
    label: "City and State"
    type: string
    sql: ${city}||' '||${state};;
  }

  dimension: individual_age {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age} ;;
    style: integer
  }

  dimension: traffic_cource_email {
    type: yesno
    sql: ${traffic_source} = 'Email';;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_of_femail_users {
    type: count
    filters: [gender: "Female"]
  }

}
