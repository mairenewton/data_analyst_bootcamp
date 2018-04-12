view: users {
  sql_table_name: public.users ;;


dimension: full_name {
  type: string
  sql: ${first_name} || ' ' ||  ${last_name} ;;
}


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

dimension: age_tier {
  type:  tier
  tiers: [ 18,25,32,40,55]
  sql:  ${age} ;;
  style:  integer
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

    dimension: days_since_signup {
    type:  number
    sql:  datediff('day', ${created_date},current_date) ;;
  }

dimension: is_new_user {
  type: yesno
  sql: ${days_since_signup} <= 120 ;;
}

dimension: days_since_signup_tier {
  type: tier
  tiers: [30,60,90,180]
sql: ${days_since_signup} ;;
style: integer
}

dimension: location {
  type:  location
  sql_latitude:  ${latitude} ;;
  sql_longitude: ${longitude} ;;
}

dimension: zip2 {
  type: zipcode
  sql: ${TABLE}.zip ;;
 map_layer_name: us_zipcode_tabulation_areas
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

  dimension: city_state {
    description: "combination of city and state"
    type: string
    sql: ${city}|| ', '  ||  ${state} ;;

  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

dimension: is_traffic_source_email_yesno {
  type: yesno
  sql:  ${traffic_source} = 'Email' ;;
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
