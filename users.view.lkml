view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_history_button {
    label: "History Button"
    sql: ${TABLE}.id ;;
    html: <a href="/explore/events_ecommerce/order_items?fields=order_items.detail*&f[users.id]={{ value }}"><button>Order History</button></a> ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type:  tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql:  ${age} ;;
    style:  integer
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
    timeframes: [raw, time, date, hour, hour_of_day, day_of_week, day_of_week_index, time_of_day, week,  month_num, month, year, quarter, quarter_of_year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

  dimension: is_new_user {
    type:  yesno
    sql:  ${days_since_signup} <= 90 ;;
  }

  dimension: days_since_signup_tier {
    type:  tier
    tiers: [0, 30, 90, 180, 360, 720]
    sql:  $days_since_signup} ;;
    style:  integer
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    link: {
      label: "Category Detail Dashboard"
      url: "/dashboards/1813?Email={{value}}"
    }
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

  dimension: full_name {
    type: string
    sql: ${first_name} || ${last_name} ;;
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

  dimension: is_email_source {
    type:  yesno
    sql:  ${traffic_source} = 'Email' ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension:  city_state {
    type:  string
    sql:  ${city} || ', ' || ${state} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_female_users {
    type:  count
    filters: {
      field:  gender
      value:  "Female"
    }
  }

  measure: percentage_female_users {
    type:  number
    value_format_name:  percent_1
    sql:  1.0*${count_female_users}/NULLIF(${count},0) ;;
  }

}
