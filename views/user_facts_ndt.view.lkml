# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: user_id {field:user_id}
      column: total_sales {}
      column: order_count {}
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
  }
  dimension: total_sales {
    type: number
  }
  dimension: order_count {
    type: number
  }
}
