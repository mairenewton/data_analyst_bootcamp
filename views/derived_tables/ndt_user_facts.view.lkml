# If necessary, uncomment the line below to include explore_source.
#include: "data_analyst_bootcamp.model.lkml"
#explore: ndt_user_facts {}

view: ndt_user_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_sale {}
      column: count {}
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: total_sale {
    value_format: "€#,##0.00"
    type: number
  }
  dimension: count {
    label: "Order Items Count Order Items"
    type: number
  }
}
