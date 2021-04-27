# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: add_a_unique_name_1615321495 {
  derived_table: {
    explore_source: order_items {
      column: product_category { field: inventory_items.product_category }
      column: product_distribution_center_id { field: inventory_items.product_distribution_center_id }
      column: count { field: inventory_items.count }
      filters: {
        field: inventory_items.created_date
        value: "7 days"
      }
    }
  }
  dimension: product_category {}
  dimension: product_distribution_center_id {
    type: number
  }
  dimension: count {
    type: number
  }
}
