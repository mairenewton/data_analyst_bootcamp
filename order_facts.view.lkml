# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: order_count {}
      column: total_sales {}
    }
  }
  dimension: id {
    type: number
  }
  dimension: order_count {
    description: "# of unique orders"
    type: number
  }
  dimension: total_sales {
    description: "Total sales"
    type: number
  }
}
