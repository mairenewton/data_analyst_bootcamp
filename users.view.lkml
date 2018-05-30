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
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: full_name {
    type: string
    sql: (${first_name}||' '||${last_name});;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff('day',${created_date}, current_date );;
  }

  dimension: is_new_user{
    description: "Who has signed up in the last 90 days"
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: tier{
    type: tier
    sql: ${days_since_signup};;
    tiers: [
      30, 60, 90, 180
    ]
    style: integer
  }

  dimension: city_state {
    type: string
    sql: ${state}||'-'||${city} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: INITCAP(${TABLE}.last_name );;
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

  dimension: age_group {
    type: tier
    sql: ${age};;
    tiers: [
      18,25,35,45,55,65,75,90
    ]
    style: integer
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
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
