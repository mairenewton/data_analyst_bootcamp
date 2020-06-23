# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: order_item_id {}
      column: user_id {}
      column: city_state { field: users.city_state }
      column: sale_price {}
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: order_item_id {
    type: number
  }
  dimension: user_id {
    type: number
  }
  dimension: city_state {}
  dimension: sale_price {
    type: number
  }
}
