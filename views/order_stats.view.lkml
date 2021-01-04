view: order_stats {
derived_table: {
  explore_source: order_items {
    column: order_id {}
    column: user_id {}
    column: count {}
    column: total_sales {}
  }
}

dimension: order_id {
  type: number
  primary_key: yes
  hidden: yes
}

dimension: user_id {
  type: number
  hidden: yes
}

dimension: count {
  type: number
  label: "Number of Items"
}

dimension: total_sales {
  type: number
  label: "Order Value"
  value_format_name: eur
}
 }
