include: "geography_dimensions.view"

view: users {

  extends: [geography_dimensions]
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age;;
  }

  measure: average_age {
    type: average
    sql:  ${age};;
  }

  measure: median_age {
    type: median
    sql:  ${age};;
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

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  parameter: goal {
    type: number
    description: "Enter goal here:"
  }

  measure: percent_to_goal {
    sql: 1.0*${count}/{% parameter goal %} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
