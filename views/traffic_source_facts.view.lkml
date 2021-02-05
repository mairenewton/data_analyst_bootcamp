# If necessary, uncomment the line below to include explore_source.
include: "/models/data_analyst_bootcamp.model.lkml"

view: traffic_source_facts {
  derived_table: {
    explore_source: order_items {
      column: count {}
      column: lifetime_revenue {field: user_facts.lifetime_revenue}
      column: lifetime_orders {field: user_facts.lifetime_order_count}
      column: user_count { field: users.count }
      column: traffic_source { field: users.traffic_source }
    }
    datagroup_trigger: order_items_update
  }
  measure: count {
    type: sum
  }
  measure: user_count {
    type: sum
  }

  measure: lifetime_revenue {type:average}
  measure: lifetime_orders {type:average}
  dimension: traffic_source {primary_key:yes}
}
