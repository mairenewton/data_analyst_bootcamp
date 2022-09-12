view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: count_items_ordered {}
      column: total_revenue {}
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: count_items_ordered {
    description: "Count of order items"
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: total_revenue_per_item {
    type: number
    sql: ${total_revenue} / NULLIF(${count_items_ordered},0) ;;
    value_format_name: usd

  }

}
