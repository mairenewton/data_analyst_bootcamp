view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: fake_primary_key {
    type: string
    sql: ${id} || ${age}
    primary_key: yes;;
  }


  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tiered {
    type: tier
    sql: ${age} ;;
    tiers: [10, 40, 60, 80]
    style: integer
  }

dimension: age_tiered_custom {
  label: "asdas"
  type:  string
  sql: CASE
WHEN ${age}  < 10 THEN 'Below 10'
WHEN ${age}  >= 10 AND ${age}  < 40 THEN '10 to 39'
WHEN ${age}  >= 40 AND ${age}  < 60 THEN '40 to 59'
WHEN ${age}  >= 60 AND ${age}  < 80 THEN '60 to 79'
WHEN ${age}  >= 80 THEN '80 or Above'
ELSE 'Undefined'
END ;;
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
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
