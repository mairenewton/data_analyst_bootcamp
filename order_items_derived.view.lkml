view: order_items_derived {
  derived_table: {

    persist_for: "24 hours"
#     datagroup_trigger: data_analyst_bootcamp_default_datagroup

    explore_source: order_items {
      column: user_id {
        field: order_items.user_id
        }
      column: order_id {
        field: order_items.order_id
        }
      column: sale_price {
        field: order_items.sale_price
        }
    }
    indexes: ["order_id"]
}

dimension: order_id {
  type: string
  sql: ${TABLE}.order_id ;;
}

measure: total_orders {
  type: sum
  sql: ${order_id} ;;
}

}
