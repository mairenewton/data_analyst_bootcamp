include: "data_analyst_bootcamp.model.lkml"

view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_item_count {}
      column: total_revenue {}
    }
  }
  dimension: id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_item_count {
    type: number
  }
}
