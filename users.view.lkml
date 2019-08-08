view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: city_comparision {
    type: string
    sql: case when {% condition city_selector %} ${city} {% endcondition %} then ${city} else 'Other Citiies' end ;;
  }

  filter: city_selector {
    type:  string
    description: "This is included in city comparion dimension"
    suggest_dimension: users.city
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tiered {
    type: tier
    style: integer
    tiers: [20, 40,50,80]
    sql: ${age} ;;
  }

  dimension: is_over_30 {
    type: string
    sql: CASE WHEN ${age}>30 THEN 'Is Over 30' ELSE 'Is Under 30' END ;;
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
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ',' || ${last_name} ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_raw}, current_date) ;;
  }

  dimension: days_since_signup_tiered {
    type: tier
    style: integer
    tiers: [10, 20, 30, 40,50,80]
    sql: ${days_since_signup} ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${days_since_signup}<=30 ;;
  }

  dimension: new_customer_since_signup_tiered {
    type: yesno
    sql: ${days_since_signup_tiered}<=30 ;;
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

  dimension: days_to_deliver {
    type: duration_day
    sql_start: ${created_raw} ;;
    sql_end: ${delivered_raw} ;;
  }



  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count_of_users_percent_of_total {
    label: "Percent of total users"
    type: percent_of_total
    sql: ${count} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, state, zip]
  }

  measure: average_user_age {
    type: average
    sql: ${age} ;;
  }
}
