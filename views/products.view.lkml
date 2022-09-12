view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # dimension: brand {
  #   type: string
  #   sql: ${TABLE}.brand ;;
  # }

  dimension: brand {
    sql: ${TABLE}.brand ;;
    link: {
      label: "Search on Google"
      url: "http://www.google.com/search?q={{ value }}"
       }

    link: {
      label: "{{ value }} Analytics Dashboard"
      url: "https://teach.corp.looker.com/dashboards-next/189?Brand={{ value }}"
      icon_url: "http://www.google.com/s2/favicons?domain=www.looker.com"
    }

    html: <a href="https://www.facebook.com/search/top?q={{ value }}"> {{value}}</a>;;

    link: {
      label: "Search Google image"
      url: "https://www.google.com/search?q={{value}}&tbm=isch"
    }

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

  dimension: name_product_button {
    label: "Product Details"
    sql: ${name} ;;
    html: <a href="/explore/data_analyst_bootcamp/order_items?fields=products.product_details*&f[products.name]={{ value }}"><button>Product Details</button></a> ;;
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

  ##------------------

  set: product_details {
  fields: [department, category, brand, name]
  }

  parameter: select_product_detail{
    type: unquoted

    allowed_value: {
      value: "Department"
    }

    allowed_value: {
      value: "Category"
    }

    allowed_value: {
      value: "Brand"
    }
  }


  dimension: dynamic_column_select {
    label_from_parameter: select_product_detail
    type: string
    sql:
    {% if select_product_detail._parameter_value == "Department" %}
      ${department}
    {% elsif select_product_detail._parameter_value == "Category" %}
      ${category}
    {% elsif select_product_detail._parameter_value == "Brand" %}
      ${brand}
    {% else %}
      'Select a field to select'
    {% endif %}
      ;;
    }


    measure: One_if_brand_selected {
      type: number
      sql: {% if products.brand._is_selected %}
              SUM(1)
            {% else %}
              SUM(0)
            {% endif %}
      ;;
    }


  # measure: dynamic_count {
  #   type: count_distinct
  #   sql: ${TABLE}.{% parameter select_product_detail %} ;;
  # }


}
