view: user_order_fact_ndt {
    derived_table: {
      datagroup_trigger: order_items
      distribution: "user_id"
      sortkeys: ["user_id"]
#       indexes: ["user_id"]

      explore_source: order_items {
        column: user_id { field: order_items.user_id }
        column: count_orders {}
        column: total_revenue {}
        column: min_order_created_date {}
        column: max_order_created_date {}
#         column: id {}
#         bind_all_filters: yes
      }
    }
    dimension: user_id {
      primary_key: yes
      hidden: yes
      type: number
    }
    dimension: lifetime_orders {
      type: number
      sql: ${TABLE}.count_orders ;;
    }
  dimension: customer_loyalty_tier {
    type: tier
    sql: ${lifetime_orders} ;;
    tiers: [0,10,25,50]
  }
    dimension: lifetime_revenue {
      value_format: "$#,##0.00"
      type: number
      sql: ${TABLE}.total_revenue ;;
    }
    dimension_group: first_order {
      type: time
      timeframes: [raw,date,week,month,year]
      sql: ${TABLE}.min_order_created_date ;;
    }
    dimension_group: latest_order {
      type: time
      timeframes: [raw,date,week,month,year]
      sql: ${TABLE}.max_order_created_date ;;
    }
  }
