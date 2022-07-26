view: ndt_user_order_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_sale_price {}
      column: count {}
    }
  }

  dimension: user_id {
    type: number
    primary_key: yes
  }
}
