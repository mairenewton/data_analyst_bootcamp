view: users {
  sql_table_name: public.users ;;


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }



  dimension: days_since_signup {
    type: number
    sql: datediff('day',${created_date},getdate()) ;;
  }

  dimension: is_new_user {
    type:  yesno
    sql: ${days_since_signup} < 90;;
  }

  dimension: city_state {
    type: string
    sql: ${city} || ' ' || ${state} ;;
  }

dimension: traffic_source_is_email {
  type: yesno
  sql: ${traffic_source} = 'Email' ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
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
    drill_fields: [id, events.count, order_items.count]
  }
}

view: users_extended {
  extends: [users]

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
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

  dimension: age_buckets {
    type: tier
    style: integer
    sql: ${age} ;;
    tiers: [18,25,45,55,65,75,90]
  }
}
