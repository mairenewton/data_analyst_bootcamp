view: users {
  sql_table_name: public.users ;;
  label: "All Users"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  # dimension: website_links {
  #   type: string

  #   sql: CONCAT(${state},${city}) ;;

  #   html:
  #   <a href="https://www.google.com/search?q={{ users.state._value}}&{{users.city._value}}"> Search </a>

  #   ;;
  # }


  # dimension: website_links {
  #   type: string

  #   sql: COALESCE(${state},${city},NULL) ;;

  #   html: {% if value != 'NULL' %} <a href=https://ivp.lightning.force.com/lightning/r/Account/{{ users.state._value }}/view><img src=https://www.salesforce.com/favicon.ico alt="image" style="width:20px;height:20px;"/></a>
  #   {% elsif value == 'NULL' %} <a href=https://ivp.lightning.force.com/lightning/r/Account/{{ users.city._value }}/view><img src=https://www.google.com/favicon.ico alt="image" style="width:20px;height:20px;"/></a>
  #   {% endif %};;
  # }

  # Age Tier

  # dimension: age_tier {
  #   type: tier
  #   tiers: [18, 25, 35, 45, 55, 65, 75, 90]
  #   sql: ${age} ;;
  #   style: integer
  # }


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

  #CONCAT

  # dimension: city_state {
  #   type: string
  #   sql: ${city} || ', ' || ${state};;
  # }


  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  # Email Source

  dimension: is_email_source {
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
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
