
view: order_summary {
  derived_table: {
    explore_source: order_items {
      column: average_spend_per_user {}
      column: order_id {}
      column: count {}
    }
  }
  dimension: average_spend_per_user {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    type: number
  }
  dimension: count {
    type: number
  }
}
