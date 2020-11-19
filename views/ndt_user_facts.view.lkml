# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: ndt_user_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {}
      column: total_sales {}

    }
  }
  dimension: id {
    type: number
  }
  dimension: order_count {
    label: "Order Items Total Orders"
    description: "A count of unique orders"
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
}
