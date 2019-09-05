# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: custom_view_hehe {
  derived_table: {
    explore_source: order_items {
      column: distinct_orders_count {}
      column: user_id {}
      column: total_sales {}
      column: min_order_created_date {}
      column: max_order_created_date {}
    }
  }
  dimension: distinct_orders_count {
    type: number
  }
  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
  dimension_group: min_order_created_date {
    type: time
    timeframes: [raw, date, week, month, year]
  }
  dimension_group: max_order_created_date {
    type: time
    timeframes: [raw, date, week, month, year]
  }

  dimension: customer_loyalty_tier {
    type: tier
    tiers: [10, 20, 30, 40, 50]
    sql: ${distinct_orders_count} ;;
  }
}
