view: users {
  sql_table_name:  public.users  ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {

    type: number
    sql: ${TABLE}.age ;;
  }

#   measure: total_revenue_new_users {
#     type: sum
#     sql: ${order_items.sale_price} ;;
#     filters:  {
#       field: users.is_new_user
#       value: "Yes"
#     }
#   }

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

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }


  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
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

  measure: count_female_users {
    type: count
    filters:  {
      field: gender
      value: "Female"
    }
  }

  measure: count_male_users {
    type: count
    filters:  {
      field: gender
      value: "Male"
    }
  }

  measure: count_selected_gender_users {
    type: count
    filters:  {
      field: is_selected_gender
      value: "Yes"
    }
  }

  measure: percent_female_users {
    type: number
    value_format_name: percent_1
    sql: 1.0*${count_female_users}/nullif(${count},0) ;;
  }

  dimension: is_selected_gender {
    type: yesno
    hidden: yes
    sql: SOMETHING FANCY ;;
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
}
