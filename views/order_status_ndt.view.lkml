# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_status_ndt {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: count_of_orders {}
      column: count_of_orders_items {}
      column: status {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: count_of_orders {
    type: number
  }
  dimension: count_of_orders_items {
    type: number
  }
  dimension: status {}

  measure: count_overall {
    type: number
  }
}
