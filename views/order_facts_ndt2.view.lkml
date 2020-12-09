view: order_facts_ndt2 {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
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
