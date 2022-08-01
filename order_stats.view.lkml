# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_stats {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: created_date {}
    }
  }
  dimension: id {
    type: number
  }
  dimension: created_date {
    type: date
  }
}
