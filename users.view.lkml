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

  dimension: age_tiered {
    type: tier
    style: integer
    tiers: [10,20,30]
    sql: ${TABLE}.age ;;
  }

  dimension:  is_over_30{
    type: yesno
    sql: ${age} > 30 ;;
  }

  dimension: city {
    group_label: "Adress Info"
    type: string
    sql: ${TABLE}.city ;;
  }


  dimension: country {
    group_label: "Adress Info"
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: full_name {
    type: string
    sql: $(${first_name} ||',' || $(${last_name} ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: $(${days_since_signup}<=30 ;;
  }

#  dimension: days_since_signup_tiered {

#    type: tier

#    style: integer

#    tiers: []


#  }




  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day,$(${created_raw},current_date ;;
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
    drill_fields: [id, first_name, last_name, state, zip]  }

  measure: overage_user_age {
    type: average
    sql: ${age} ;;
  }

  measure: count_of_users_percet_of_total {
    label: "Percent of total Users"
    type: percent_of_total
    sql: ${count} ;;
  }

  measure: count_users_running_total {
    type: running_total
    sql: $(${count};;
  }

  measure: count_females {
    label: "Count of Female Users"
    type: count
   drill_fields: [id,first_name,last_name,state,zip ]
    filters: {
    field: gender
    value: "Female"
    }

  }
}
