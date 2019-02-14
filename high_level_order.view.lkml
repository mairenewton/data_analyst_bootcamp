include: "data_analyst_bootcamp.model.lkml"

view: high_level_order {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: id {}
      column: count {}
      filters: {
        field: order_items.created_date
        value: "30 days"
      }
    }
  }
  dimension: order_id {
    primary_key: yes
  }
  dimension: id {
    type: number
  }
  dimension: count {
    type: number
  }

}
