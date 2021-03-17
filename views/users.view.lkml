view: users {
  sql_table_name: public.users ;;
  # derived_table: {
  #   sql:
  #   select * from (
  #   select *, row_number(created_at) over(partition by users.id) as row_number from public.users
  #   )raw_data where row_number=1
  #   ;;
  # }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age;;
  }

  dimension: age_in_months {
    type: number
    sql: ${age} *12 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state]
  }

  dimension: state_is_new_york {
    type: yesno
    sql: ${state} = 'New York' ;;
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

  dimension: age_tier {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    sql: ${age} ;;
    style: integer
  }


  dimension: email {
    type: string
    sql: ${TABLE}.email;;
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
    sql: left(${TABLE}.last_name,1) ;;
  }

  dimension: first_and_last_name {
    type: string
    sql: ${first_name} || '-' || ${last_name} ;;
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
    label: "User Count"
    # hidden: yes
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: sum_age {
    type: sum
    sql: ${age} ;;
  }



  # measure:  {}
}
