view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Search on Google"
      url: "https://www.google.com/search?q={{ value }}"
    }

    link: {
      label: "{{ value }} Dashboard"
      url: "https://teach.corp.looker.com/dashboards-next/189?Brand= {{value}}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.looker.com"
    }

  }


  dimension: Link_to_Pulse_dashboard {
    sql: ${brand} ;;
    html: <a href= "https://teach.corp.looker.com/dashboards-next/189"> <button> {{value}} <button> </a>;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;

  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count_products {
    type: count
    drill_fields: [category, brand, department]
  }

  parameter: select_product_detail {
    type: unquoted
    default_value: "deparment"
    allowed_value: {
      value: "department"
    }
    allowed_value: {
      value: "category"
    }

    allowed_value: {
      value: "brand"
    }

  }


}
