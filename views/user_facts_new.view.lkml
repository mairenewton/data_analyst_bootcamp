view: user_facts_ndt {
  derived_table: {
    explore_source: order_items{
      column: user_id {}
      column: lifetime_spend { field: order_items.total_sales}
      column: lifetime_orders{ field: order_items.count_orders}
      column: lifetime_items { field: order_items.count}
    }
  }

  dimension:  user_id{
    label: "Order & Items User ID"
    type:  number
    hidden:  yes
    primary_key:yes

  }

}
