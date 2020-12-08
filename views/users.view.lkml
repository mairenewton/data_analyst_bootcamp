view: users {
  sql_table_name: public.users ;;

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
    type: tier
    sql: ${age} ;;
    tiers: [18,40,60]
    style: integer
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date},current_date) ;;
  }

  dimension_group: as_customer {
    type: duration
    intervals: [day,week,month,year]
    sql_start: ${created_date} ;;
    sql_end: current_date ;;
  }

#geography {
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
#}

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source}='Email' ;;
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      day_of_month,
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

  measure: customer_count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: customer_growth {
    type: percent_of_previous
    sql: ${customer_count} ;;
  }


  set: show_in_order_items {
    fields: [age,age_tier,state]
  }
}
