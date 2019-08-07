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
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: age_tiered {
    type: tier
    style: integer
    tiers: [20,40,50,80]
    sql: ${age} ;;
  }

  dimension: is_over_30 {
    type: yesno
    sql: ${age} > 30 ;;
  }

  dimension: is_over_30_custom {
    type: string
    sql: CASE WHEN ${age} > 30 THEN 'Is Over 30' ELSE 'Is Under 30' END;;
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
    sql: ${first_name} ||' ' || ${last_name} ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

  dimension: new_customer {
    type: yesno
    sql: ${days_since_signup} <= 30 ;;
  }

  dimension: signup_tiered {
    type: tier
    style: integer
    tiers: [30,90,140,300]
    sql: ${days_since_signup} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, state, zip]
  }

  measure: count_of_users_percent_of_total{
    label: "Percent of Users Signed up"
    type: percent_of_total
    sql: ${count} ;;
  }
  measure: running_total {
    type: running_total
    sql: ${count} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }
}
