view: users {
  sql_table_name: public.users ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: is_over_30 {
    type: yesno
    sql: ${age} > 30 ;;
  }

  dimension: age_tier {
    type: tier
    sql: ${age} ;;
    tiers: [20,40,60,80,100]
    style: integer
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql:

    CASE WHEN ${TABLE}.country = 'UK' THEN 'United Kingdom' ELSE ${TABLE}.country END

    ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      day_of_week,
      time,
      date,
      week,
      month,
      quarter,
      month_name,
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

  dimension: french_full_name {
    type: string
    sql: LOWER(${first_name}) || ' ' || ${last_name} ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: point_location {
    type: location
    sql_latitude: ${latitude}  ;;
    sql_longitude: ${longitude}  ;;
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

  measure: count_users {
    type: count
    drill_fields: [id, last_name, first_name]
  }

  measure: count_over_30 {
    group_label: "Age related measures"
    type: count
    drill_fields: [id, last_name, first_name]
    filters: {
      field: is_over_30
      value: "yes"
    }
  }

  measure: percent_over_30 {
    description: "This is the percent of all users over 30 - can be used with all dimensions and measures"
    group_label: "Age related measures"
    type: number
    sql: 1.0*${count_over_30} / ${count_users} ;;
    value_format_name: percent_1
  }

  measure: average_age {
    label: "Mean age"
    group_label: "Age related measures"
    type: average
    sql: ${age} ;;
  }

  measure: max_age {
    group_label: "Age related measures"
    type: max
    sql: ${age} ;;
  }

  measure: min_age {
    group_label: "Age related measures"
    type: min
    sql: ${age} ;;
  }

  measure: median_age {
    group_label: "Age related measures"
    type: median
    sql: ${age} ;;
  }

  measure: spend_per_user {
    type: number
    sql: ${order_items.total_spend} / ${count_users} ;;
    value_format_name: usd
  }

}
