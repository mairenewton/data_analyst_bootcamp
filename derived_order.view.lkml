# If necessary, uncomment the line below to include explore_source.
include: "data_analyst_bootcamp.model.lkml"

view: derived_order {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: order_item_count {}
      column: sum_total {}
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: sum_total {
    type: number
  }
}
