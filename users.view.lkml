view: users {
  sql_table_name: public.users ;;




  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  #dimension: fake_primary_key_1 {
  #  type: string
  #  sql: ${age} || ${city} ;;
  #  primary_key: yes
  #}

  #dimension: fake_primary_key_2 {
  #  type: string
  #  sql: CONCAT(${age}, ${city}) ;;
  #  primary_key: no
  #}

  dimension: is_over_30 {
    type: yesno
    sql: ${age} > 30 ;;
  }

  dimension: age_tiered {
    type: tier
    tiers: [20, 40, 60, 80]
    sql: ${age} ;;
    style: integer
  }

  dimension: tiering_age_sample{
    type: string
    sql:  CASE
            WHEN  ${age}  < 20 THEN 'Abaixo 20'
            WHEN  ${age}  >= 20 AND ${age}  < 40 THEN '20 a 39'
            WHEN  ${age}  >= 40 AND  ${age}  < 60 THEN '40 a 59'
            WHEN  ${age}  >= 60 AND  ${age}  < 80 THEN '60 a 79'
            WHEN  ${age}  >= 80 THEN '80 or Acima'
            ELSE 'Undefined'
          END;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
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
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count_running_total {
    type: running_total
    sql: ${count};;
  }

  measure: average_minus_count {
    type: number
    sql: ${count} - ${average_age} ;;
  }
}
