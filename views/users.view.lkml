view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_group {
    type: tier
    sql: ${age} ;;
    tiers: [18,31,51,71]
    style: integer
  }

  dimension: city {
    group_label: "Address"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Address"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  #beccause using duration looker with name Duration as A user with list of intervals below: in viz shows as hour_as_a_user, days_as_a_user
  dimension_group: as_a_user {
      type:  duration
      sql_start:  ${created_raw} ;;
      sql_end:  current_date ;;
      intervals: [hour,day,week,month,year]
  }

  dimension: is_new_user {
    type:  yesno
    sql: ${days_as_a_user} < 90 ;;
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

  dimension: days_since_signup {
    type:  number
    sql:  DATEDIFF(day,${created_date},current_date) ;;
  }

  dimension: is_new_customer {
    type:  yesno
    sql:  ${days_since_signup}<=90 ;;
  }

  dimension: days_since_signup_tier {
    type: tier
    tiers: [30,90,180,360,720]
    sql:  ${days_since_signup} ;;
    style:  integer
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: initcap(${TABLE}.first_name) ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: initcap(${TABLE}.last_name) ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
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
    group_label: "Address"
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    group_label: "Address"
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count_of_users {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: min_age {
    type: min
    sql: ${age} ;;
  }
  measure: max_age {
    type: max
    sql: ${age} ;;
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
    value_format_name: decimal_0
  }
}
