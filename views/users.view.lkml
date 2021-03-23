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

  dimension: age_buckets {
    type: tier
    sql: ${age} ;;
    tiers: [0,18,25,35,45,55,65,75,90]
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
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: country {
    group_label: "Location Details"
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

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    sql: ${days_since_signup} ;;
    tiers: [0,30,90,180,360,720]
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

  dimension: full_name {
    type: string
    sql: ${first_name} || '' || ${last_name} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
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
}
