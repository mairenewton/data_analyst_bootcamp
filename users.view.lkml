view: users {
  sql_table_name: public.users ;;

  dimension: id {
  primary_key: yes
  hidden:  yes
    type: number
    sql: ${TABLE}.id ;;
  }

#dimension: fake_primary_key {
#   type: string
#    sql:  ${id} || ${age} ;;
#    primary_key: yes
#}

  dimension: age {
    type: number
    sql: ${TABLE}.age
    style: integer;;

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

  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name}  ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date);;
  }

  dimension: is_male {
    type: yesno
    sql: ${gender} = 'Male' ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [10,20,30,40,50,60]
    style: integer
    sql: ${age} ;;
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
}
