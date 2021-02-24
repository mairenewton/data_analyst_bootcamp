view: users_order_item_count {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: count {}
      }
    }
    dimension: id {
      type: number
    }
    measure: count {
      type: sum
    }
}
