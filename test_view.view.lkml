# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: test_view {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: count {}
    }
  }
  dimension: id {
    type: number
  }
  dimension: count {
    type: number
  }
}
