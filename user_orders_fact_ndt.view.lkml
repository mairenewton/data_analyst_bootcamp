# If necessary, uncomment the line below to include explore_source.
 include: "/models/data_analyst_bootcamp.model.lkml"

view: user_orders_fact_ndt {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: status {}
      column: count {}
      column: user_count { field: users.count }
      filters: {
        field: order_items.created_date
        value: "before today"
      }
    }
#     sql_trigger_value: select current_date ;;
# persist_for: "4 hours"
  }
  dimension: created_date {
    type: date
  }
  dimension: status {}
  dimension: user_count {
    type: number
    sql: {TABLE}.users_count ;;
  }

  measure: count {
    type: number
  }
}


view: test_ndt {
  derived_table: {
    explore_source: order_items {
      column: id { }
      column: total_revenue {field:total_sales_price}
      column: order_count {field: count}
      derived_column: average_revenue_per_item {sql: total_revenue/order_count )
      derived_column: rank { sql: rank() over(order by average_revenue_per_item desc) ;; }
    }
  }
}
