#native_derived_table

# If necessary, uncomment the line below to include explore_source.
 include: "/models/data_analyst_bootcamp.model.lkml"

view: test_rollup {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: order_count {}
    }
    datagroup_trigger: data_analyst_bootcamp_default_datagroup
  }
  dimension: user_id {
    type: number

  }
  dimension: order_count {
    label: "Order Items Total Orders"
    description: "A count of unique orders"
    type: number
  }
}
