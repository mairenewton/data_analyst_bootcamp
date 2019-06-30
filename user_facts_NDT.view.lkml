view: user_fact_NDT {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {}
      column: total_sales {}
    }
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: order_count {
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
}
