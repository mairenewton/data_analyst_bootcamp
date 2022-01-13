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

  #comment

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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  #AMAZON REDSHIFT SQL syntax
  dimension: full_name {
    type: string
    sql: ${TABLE}.first_name || ' ' || ${TABLE}.last_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date},CURRENT_DATE) ;;
  }

  dimension: is_new_user {
   type: yesno
    sql: ${days_since_signup} < 90 ;;
  }

  # creating tier diemsion
  dimension: days_since_sugnup_tier {
    type: tier
    tiers: [0,30,90,180,360,720]
    sql: ${days_since_signup} ;;
    style: integer
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

  # dimension: location {
  #   type: string
  #   sql: ${city} || ', ' || ${state} ;;
  # }

  # dimension: age_tier {
  #   type: tier
  #   tiers: []
  #   sql:  ;;
  #   style: integer
  # }


  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

}
