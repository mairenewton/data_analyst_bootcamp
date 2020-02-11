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
    group_label: "User Geo"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: "User Geo"
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
    group_label: "User Geo"
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

  dimension: citystate {
    label: "City,State"
    type:  string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: traffic_source_bool {
    type:  yesno
    sql:  ${traffic_source} = "Email" ;;
  }

dimension: age_groups  {
  type:  tier
  sql:  ${age} ;;
  tiers: [18, 25, 35, 45, 55, 65, 75, 90]
  style:  integer
}

measure: total_female_users {
  type:  count
  filters: {
    field: gender
    value: "Female"
  }
}

# need to force into a float
  measure: pct_of_female_users {
    label: "Percent of Female Users"
    type:  number
    sql: 1.0 * ${total_female_users}/${count} ;;
    value_format_name: percent_2
  }



}
