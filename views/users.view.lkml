#
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
    tiers: [18,25,35,45,55,65,75,85]
    sql: ${age} ;;
    style: integer
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

  dimension: days_since_signup_2 {
    description: "Days since the user account was created"
    hidden: yes
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }


  dimension_group: since_signup {
    type: duration
    intervals: [day, week, month, quarter, year ]
    sql_start: ${created_date} ;;
    sql_end: current_date ;;
  }



  dimension: is_new_customer {
    description: "If signed in the last 90 days, yes"
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [0,30,90,180,360]
    style: integer
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
    #sql: concat(initcap(${first_name}),' ', initcap(${last_name})) ;;
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
    sql: ${city} || ' - ' || ${state}  ;;

  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }




  dimension: is_traffic_source_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
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
    type: count
    filters: [gender: "Female"]
  }


  measure: percent_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0 * ${count_female_users}/ NULLIF(${count}, 0) ;;
  }





}
