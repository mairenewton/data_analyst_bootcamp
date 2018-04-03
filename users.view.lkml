view: users {
  sql_table_name: public.users ;;

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type:  tier
    sql:  ${age} ;;
    tiers: [18,25,35,45,55,65,75,90]
    style:  integer
  }

  dimension: days_since_signup {
    type:  number
    sql:  DATEDIFF('day', ${created_date}, GETDATE()) ;;
  }

  dimension: is_new_user {
    type:  yesno
    sql:  ${days_since_signup} < 90 ;;
  }

  dimension: city_state {
    type:  string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: traffic_source_is_email   {
    type:  yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    drill_fields: [id, events.count, order_items.count]
  }
}
