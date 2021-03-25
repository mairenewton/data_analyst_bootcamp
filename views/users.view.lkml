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
    link: {
      label: "Link to a dashboard"
      url: "/dashboards/1813?Email={{value | encode_uri}}"
      icon_url: "https://www.looker.com/favicon.ico"

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
    type: yesno
    sql: ${traffic_source} = 'Email' ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: city_state {
    type: string
    sql: ${city} || ', ' || ${state} ;;
    link: {
      label: "Link to a dashboard"
      url: "/dashboards/1813?Email={{email._value}}"  ### links the email now (will filter on this name's email)
      icon_url: "https://www.looker.com/favicon.ico"
    }
    link: {
      label: "Link to a dashboard"
      url: "https://teach.corp.looker.com/explore/advanced_data_analyst_bootcamp/order_items?fields=order_items.order_id,order_items.status,order_items.profit_margin&f[users.id]={{id._value}}&sorts=order_items.profit_margin+desc&limit=10"
    }
  }

  dimension: name {
    type: string
    sql: ${first_name} || ', ' || ${last_name} ;;
    link: {
      label: "Link to a dashboard"
      url: "/dashboards/1813?Email={{email._value}}"  ### links the email now (will filter on this name's email)
      icon_url: "https://www.looker.com/favicon.ico"
    }
    link: {
      label: "Link to an Explore"
      url: "https://teach.corp.looker.com/explore/advanced_data_analyst_bootcamp/order_items?fields=order_items.order_id,order_items.status,order_items.profit_margin&f[users.id]={{id._value}}&f[users.state]={{_filters['users.state']}}&sorts=order_items.profit_margin+desc&limit=10"
    }
    ### checks if brand is selected then also filter on that otherwise doesn't filter
    # link: {
    #   label: "Link to an Explore"
    #   url: "https://teach.corp.looker.com/explore/advanced_data_analyst_bootcamp/order_items?fields=order_items.order_id,order_items.status,order_items.profit_margin&f[users.id]={{id._value}}&f[users.state]={{ _filters['users.state'] }}{% if products.brand._is_selected %}&f[products.brand]={{ products.brand | encode_uri }}{% endif %}&sorts=order_items.profit_margin+desc&limit=10"
    # }
  }

  dimension: age_groups {
    type: tier
    tiers: [18,25,35,45,55,65,75,90]
    sql: ${age} ;;
    style: integer
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
