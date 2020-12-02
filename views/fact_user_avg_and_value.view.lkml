view: fact_user_avg_and_value {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: total_revenue {}
      column: order_item_count {}
      column: country {field:users.country}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_revenue desc);;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_item_count {
    type: number
  }
}
