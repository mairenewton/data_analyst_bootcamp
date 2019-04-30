view: users2 {
  derived_table: {
    sql: select * from public.users
    ;;
  }

  parameter: my_parameter {
    type: string

    allowed_value: {
      label: "1000"
      value: "1000"
    }
    allowed_value: {
      label: "500"
      value: "500"
    }
  }

  filter: my_filter {
    label: "State to Compare"
    type: string

    default_value: "California"
  }

  dimension: state_comparitor {
    type: string
    sql:
    CASE
      WHEN {% condition my_filter %} ${state} {% endcondition %} THEN ${state}
      ELSE 'Other'
    END
    ;;
  }

  dimension: parameter_values {
    type: string
    sql: {% parameter my_parameter %} ;;
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

  dimension: age_bucketed {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60]
    style: integer
    sql: ${TABLE}.age ;;
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
    drill_fields: [id, first_name, last_name, state, zip]
  }

  measure: avg_age {
    type: average
    sql: ${age} ;;
  }
}
