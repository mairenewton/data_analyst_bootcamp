view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }



  dimension: combined_city_state {
    type:  string
    sql: ${city} || ', ' || ${state}  ;;
  }


  dimension: age_buckets {
    type: tier
    tiers: [18,25,35,45,55,65,75,90]
    sql:  ${age} ;;
    style: integer
  }


  dimension: Email_source {
    type:  yesno
    sql: ${traffic_source} = 'Email' ;;
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
    link: {
      label: "eCommerce sample user dashboard"
      url: "https://teach.corp.looker.com/dashboards/1813?Email={{value}}&filter_config=%7B%22Email%22:%5B%7B%22type%22:%22%3D%22,%22values%22:%5B%7B%22constant%22:%22%22%7D,%7B%7D%5D,%22id%22:2%7D%5D%7D"
      icon_url: "https://www.google.com/s2/favicons?domain=looker.com"
    }
    #required_access_grants: [PII_grant]
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    required_access_grants: [PII_grant]
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    required_access_grants: [PII_grant]
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

}
