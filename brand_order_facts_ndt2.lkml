# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: brand_order_facts_ndt2 {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
    }
  }
  dimension: brand {}
  dimension: total_sales {
    type: number
  }
}
