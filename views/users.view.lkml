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
    group_label: "Geo"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Geo"
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
      day_of_week,
      day_of_week_index,
      quarter,
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: duration_day
    sql_start: ${created_date} ;;
    sql_end: current_date ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} < 90 ;;
  }

  dimension: days_since_signup_tiers {
    type: tier
    tiers: [20,40,60,90,120,150]
    sql: ${days_since_signup} ;;
    style: classic
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    type: string
    sql: ${first_name}||' '||${last_name} ;;
  }

  dimension: latitude {
    group_label: "Geo"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Geo"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    description: "Geo State"
    group_label: "Geo"
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

  measure: count {
    label: "Users Count"
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

}
