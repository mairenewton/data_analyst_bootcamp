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

dimension: age_tier
{
  type: tier
  tiers: [18,25,35,45,55,65,75,90]
  sql: ${age} ;;
  style: integer
}
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_state {
    type: string
    sql: ${city} || ',' || ${state} ;;
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
    tiers: [0, 30, 90, 180, 360, 720]
    sql: ${days_since_signup} ;;
    style: integer
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: signup {
    type: duration
    intervals: [day, week, month, year]
    sql_start: ${created_date};;
    sql_end: current_date ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: Full_name {
    type: string
    description: "first and last name of consultant"
    sql: ${first_name} || ${last_name} ;;
  }



  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
