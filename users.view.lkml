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
      time, time_of_day,
      date, day_of_week,
      week,
      month, month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

#   dimension: days_since_signup {
#     type: number
#     sql: DATEDIFF(day, ${created_date}, CURRENT_DATE) ;;
#   }

  dimension: days_since_signup_2 {
    label: "Days Since User Signup"
    description: "Amount of days between a user's signup and today's date."
    type: duration_day
    sql_start: ${created_date} ;;
    sql_end: CURRENT_DATE ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup_2} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    tiers: [50,100,200,500]
    style: integer
    sql: ${days_since_signup_2} ;;
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

  dimension: full_name {
#     type: string
  sql: ${first_name} || ${last_name} ;;
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

  measure: count_female_users {
    type: count
    filters:  {
      field: gender
      value: "Female"
    }

  }


}
