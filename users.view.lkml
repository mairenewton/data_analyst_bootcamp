
view: users {
  sql_table_name: public.users ;;
  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: age {
    group_label: "Age info"
    type: number
    sql: ${TABLE}.age ;;
  }
  dimension: age_tiered {
    group_label: "Age info"
    type: tier
    sql: ${age} ;;
    tiers: [20, 40, 60, 80]
    style: integer
  }
  dimension: age_tiered_custom {
    group_label: "Age info"
    label: "Nice age tiered"
    type: string
    sql: CASE
      WHEN ${age} <= 20 THEN 'Super young'
      WHEN ${age}  > 20  THEN 'Old'
      ELSE 'Undefined' END ;;
  }
  dimension: is_over_30 {
    group_label: "Age info"
    type: yesno
    sql: ${age} > 30 ;;
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
    convert_tz: no
  }
  dimension: days_since_created {
    type:  number
    sql: DATEDIFF(day, ${created_raw}, CURRENT_DATE)  ;;
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
    sql: ROUND(${TABLE}.latitude, 4) ;;
  }
  dimension: longitude {
    type: number
    sql: ROUND(${TABLE}.longitude, 4) ;;
  }
  dimension: user_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
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
    group_label: "All my metrics"
    label: "Count of users"
    description: "This calculates the number of users"
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
  measure: count_running_total {
    group_label: "All my metrics"
    type: running_total
    sql: ${count} ;;
  }
  measure: count_over_30 {
    group_label: "All my metrics"
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
    filters: {
      field: is_over_30
      value: "yes"
    }
  }
  measure: percet_over_30 {
    group_label: "All my metrics"
    type: number
    sql: 1.00 * ${count_over_30} / ${count} ;;
    value_format_name: percent_2
  }
  measure: average_age {
    group_label: "All my metrics"
    type: average
    sql: ${age} ;;
    value_format_name: decimal_2
    drill_fields: [first_name, last_name, age]
  }
}
