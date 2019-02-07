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

  dimension: is_user_over_18 {
    type: yesno #boolean field
    sql: ${age} > 18 ;;
  }

dimension: age_tier{
  type: tier
  tiers: [0,18,25,30,38]
  style: integer
  sql: ${age} ;;
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

  dimension: city_state {
    type: string
    sql: ${city} ||', ' || ${state} ;;

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

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source}= 'Email' ;;
  }


dimension: is_email_Traffic_source {
  type: yesno
  sql: ${traffic_source} = 'Email' ;;
}


  measure: count_users {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }
}
