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

  dimension: age_bucket {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 76, 90]
    sql: ${age} ;;
    style: integer
  }

  dimension: city {
    group_label: "Address"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_state {
    label: "City, State"
    group_label: "Address"
    type: string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: country {
    group_label: "Address"
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

  dimension: days_on_our_site {
    hidden: yes
    type: number
    sql: datediff('day',${created_raw}, current_date) ;;
  }

# Best practice vs days_on_our_site dimension
  dimension_group: on_site {
    type: duration
    intervals: [hour, day, week, month]
    sql_start: ${created_raw} ;;
    sql_end: current_date ;;
  }

  dimension: first_name {
    hidden: yes
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
    sql: ${days_on_our_site} < 90 ;;
  }


  dimension: traffic_source_is_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: last_name {
    hidden: yes
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    group_label: "Address"
    type: string
    sql: ${TABLE}.state ;;
    drill_fields: [city]
  }

  dimension: traffic_source {
    description: "Referral site that directed users to our site."
    type: string
    sql: ${TABLE}.traffic_source ;;
  }


  dimension: zip {
    label: "ZIP"
    group_label: "Address"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_of_users {
    type: count_distinct
    sql: ${id};;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    drill_fields: [user_details*, age, -country]
  }

  set: user_details {
    fields: [id, full_name, city_state, country]
  }
}
