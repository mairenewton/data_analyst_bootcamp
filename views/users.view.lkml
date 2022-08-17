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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }


#     #--------------------------
#     #  -------SOLUTION---------

#     dimension: days_since_signup {
#       type: number
#       sql:  DATEDIFF(day, ${created_date}, current_date) ;;
#     }

#     dimension: is_new_customer {
#       description: "New customer (yes) if sign up less than 90 days (inclusive)"
#       type: yesno
#       sql: ${days_since_signup} <= 90  ;;
#     }

#       dimension: days_since_signup_tier {
#         type: tier
#         sql: ${days_since_signup} ;;
#         tiers: [0, 30, 90, 180, 360, 720]
#         style: integer
#       }

#       #note day interval would create the same dimension as days_since_signup
#       dimension_group: since_signup {
#         type: duration
#         intervals: [week, month, quarter, year]
#         sql_start: ${TABLE}.created_date ;;
#         sql_end: current_date;;
#       }

# #2.1 Exercise 1 - Task 1/2 Solutions
#       dimension: city_state {
#         type: string
#         sql: ${city} || '-' || ${state} ;;
#       }

#       dimension: age_group {
#         type: tier
#         tiers: [18, 25, 35, 45, 55, 65, 75, 90]
#         sql: ${age} ;;
#         style: integer
#       }

#       dimension: is_traffic_source_online {
#         type: yesno
#         sql: ${traffic_source} = 'Email' ;;
#       }

}
