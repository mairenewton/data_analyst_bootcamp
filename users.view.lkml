view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  hidden: yes
  }


  dimension: age {
    label: "Alder"
    type: number
    sql: ${TABLE}.age ;;
  }

dimension: age_tiered {
  type: tier
  tiers: [20,40,60,80]
  sql: ${age} ;;
  style: integer
}

dimension: age_bucket{
type: string
sql: CASE
WHEN ${age} < 20 THEN 'kid'
WHEN ${age}  >= 20 AND ${age}  < 40 THEN 'russæøå'
WHEN ${age}  >= 40 AND ${age}  < 60 THEN 'mid-life-crisis'
WHEN ${age}  >= 60 AND ${age}  < 80 THEN 'retired'
WHEN ${age}  >= 80 THEN 'grandparent'
ELSE 'Undefined'
End;;
}

dimension: is_over_30{
  type: yesno
  sql: ${age}>30 ;;

}

measure: avg_age {
type:average
sql: ${age} ;;
value_format_name: decimal_1

}



  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
    group_label: "Address"
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
    group_label: "Address"
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
    group_label: "Address"
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    group_label: "Address"
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
    group_label: "Address"
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
