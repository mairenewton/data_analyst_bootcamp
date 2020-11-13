include: "/views/geography_columns.view"
view: users {

  extends: [geography_columns]

  sql_table_name: public.users ;;

  filter: incoming_traffic_source {
    type: string
    suggest_dimension:
    users.traffic_source
    suggest_explore: users
  }

  dimension: hidden_traffic_source_filter {
    hidden: yes
    type: yesno
    sql: {% condition incoming_traffic_source %} ${traffic_source} {% endcondition %} ;;
  }

  measure: changeable_count_measure {
    type: count_distinct
    sql: ${id} ;;
    filters: [
      hidden_traffic_source_filter: "Yes"
    ]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_group {
    type: tier
    sql: ${age} ;;
    tiers: [18,25,35,45,55,65,75,90]
    style: integer
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
      day_of_month,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    #required_access_grants: [is_pii_viewer]
    link: {
      label: "eCommerce Sample User Dashboard"
      url: "/dashboards/1813?Email={{ value | uri }}"
      icon_url: "https://www.looker.com/favicon.ico"
    }
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    required_access_grants: [is_pii_viewer]
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    required_access_grants: [is_pii_viewer]
  }

  dimension: city_state {
    type: string
    sql: ${city} || ', ' || ${state} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: from_email {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
