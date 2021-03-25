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
      label: "Google"
      url: "https://www.google.com/search?q={{value | encode_uri}}"
      icon_url: "https://www.google.com/favicon.ico"
    }
    link: {
      label: "Order Details {{value}}"
      url: "/dashboards/694?Brand={{value | encode_uri}}&States=&Date=30%20days"
      icon_url: "https://www.looker.com/favicon.ico"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "View Category Details"
      url: "/explore/data_analyst_bootcamp/order_items?fields=products.category,products.name,inventory_items.count&f[products.category]={{value | uri_encode}}&sorts=inventory_items.count+desc&limit=500"
    }
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

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
