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

  dimension: full_name {
      type: string
      sql: ${first_name} || ' ' || ${last_name}  ;;
  }

  dimension: days_since_signup {
      type: number
      sql: datediff(day, ${created_date}, current_date) ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup}<90 ;;
  }

  dimension: days_since_signup_tier  {
    type: tier
    tiers: [0,30,90,180,360,720]
    sql: ${days_since_signup} ;;
    style: integer
  }

  dimension: city_State {
    type: string
    sql: ${city} || ', ' || ${state};;
  }

  dimension: sourceIsEmail {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: age_Group {
    type: tier
    tiers: [18,25,35,45,55,65,75,90]
    sql: ${age} ;;
    style: integer
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
