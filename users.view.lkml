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
    group_label: "Customer Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "Customer Location"
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
  group_label: "Customer Location"
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
    hidden:  yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    hidden:  yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    group_label: "Customer Location"
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
    drill_fields: [detail*]
  }

  # --- set of fields for drilling ----
  set: detail {
    fields: [ id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_male_users {
    type:  count
    filters: {
      field:  gender
      value: "Male"
    }
  }

  measure: percentage_male_users {
    type:  number
    sql:  ${count_male_users} / nullif(${count}, 0) ;;
    value_format_name: percent_1
  }

measure:  average_spend_per_user {
  type:  number
  sql:  order_items. ;;
}

measure: count3 {
  type:  count

}

}
