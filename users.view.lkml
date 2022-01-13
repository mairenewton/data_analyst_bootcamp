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
    tiers:[18,25,35,45,55,65]
    style: integer
    #style: classic
    sql:${TABLE}.age;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_state_test  {
    description: "city and test with underscore in between"
    type: string
    sql:  ${city}||,'_'||${state} ;;
  }

  dimension: city_state {
    description: "test, city state combined field"
    type:  string
    sql: ${city}||', '||${state} ;;
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
    description: "number of days since a user signed up. This is a best practice"
    type: number
    sql:Datediff(day, ${created_date},current_date) ;;
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
    description: "learning example of strings and concat (type of sql language may vary)"
    type:  string
    sql:  initcap(lower(${first_name}))||' '||${last_name} ;;
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
    drill_fields: [city]
  }

  dimension: days_since_signup_tiered {
    description: "created learning field, demonstrating tiers"
    type:  tier
    tiers: [0, 30, 90, 180, 360, 720, 900]
    sql:  ${days_since_signup} ;;
    style:  integer
  }

  dimension: age_bucket {
    description: "testing the tiers on age buckets"
    type: tier
    tiers: [18,25,35,45,55,65,75,90]
    sql: ${age} ;;
    style: interval
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }


  dimension: is_email_test {
    case_sensitive: no
    type: yesno
    sql: ${traffic_source} like 'Email' ;;
  }


  dimension: was_email {
    case_sensitive: no
    description: "was this an email to target the user"
    type: yesno
    sql: ${traffic_source} like 'Email' ;;
  }

  dimension: is_customer_new {
    description: "created field, definition of yesno"
    type: yesno
    sql: ${days_since_signup} <= 90 ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }


  ####MEASURES####

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: count_females {
    type: count
    filters: [gender: "Female"]
  }
}
