view: user_sales_count_native_dt {

  derived_table: {
    #datagroup_trigger: order_items
    #distribution: "user_id"
    #sortkeys: ["user_id"]
    explore_source: order_items {
      #column: state {}
      column: user_id {}
      column: max_order_created_date {}
      column: min_order_created_date {}
      column: total_sale_price {}
      column: count_orders {}
      bind_filters: {
        from_field:order_items.status
        to_field: :order_items.status

      }


      bind_filters: {
        from_field:order_items.created_date
        to_field: :order_items.created_date

      }

      bind_filters: {
        from_field:user_sales_count_native_dt.user_name_filter_only
        to_field: :users.first_name

      }


      derived_column: customer_acquisition_date_rank {
        sql:rank() over (order by min_order_created_date) ;;


      }




    }
  }


  filter: user_name_filter_only {
    type: string
    suggest_explore: order_items
    suggest_dimension: users.first_name
  }

  dimension: user_id {
    type: number
  }
  dimension: max_order_created_date {
    type: number
  }
  dimension: min_order_created_date {
    type: number
  }
  dimension: total_sale_price {
    type: number
  }
  dimension: count_orders {
    type: number
  }

  dimension_group: first_order {
    type: time
    timeframes:[raw,date,week,month,year]
    sql: ${TABLE}.min_order_created_date ;;
  }

  dimension_group: latest_order {
    type: time
    timeframes:[raw,date,week,month,year]
    sql: ${TABLE}.max_order_created_date ;;
  }

  dimension: customer_acquisition_date_rank {
    type: number
  }

  dimension: is_early_100 {
    type: yesno
    sql: ${customer_acquisition_date_rank} <=100 ;;
  }


  }
