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
    tiers: [18,25,35,45,55,65,75,90]
    sql: ${age} ;;
    style: integer
  }

  dimension: city {
    group_label: "Location Details"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_state {
    group_label: "Location Details"
    type: string
    sql: ${city} || ',' ||${state};;
  }

  dimension: country {
    group_label: "Location Details"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state,city]
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
      month_num,
      quarter,
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    label: "Days a Customer"
    description: "The number of days since user signed up"
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date);;
  }

  dimension: days_since_signup_tier{
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [0,30,90,180,360,720]
    style: integer
  }


  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    group_label: "Location Details"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "Location Details"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    group_label: "Location Details"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    group_label: "Location Details"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_female_users  {
    type: count
    filters: [gender: "Female"]
    value_format_name: decimal_0
  }

  measure: percentage_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}/NULLIF(${count},0) ;;
  }




}
