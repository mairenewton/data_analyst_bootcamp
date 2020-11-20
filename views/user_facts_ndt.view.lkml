# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: user_facts {
      column: avg_lifetime_orders {}
      column: avg_lifetime_sales {}
      column: state { field: users.state }
    }
  }
  dimension: avg_lifetime_orders {
    type: number
  }
  dimension: avg_lifetime_sales {
    type: number
  }
  dimension: state {}
}
