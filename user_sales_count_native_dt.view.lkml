view: user_sales_count_native_dt {

  derived_table: {
    datagroup_trigger: order_items
    distribution: "user_id"
    sortkeys: ["user_id"]
    explore_source: order_items {
      column: user_id {}
      column: max_order_created_date {}
      column: min_order_created_date {}
      column: total_sale_price {}
      column: count_orders {}
    }
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





  }
