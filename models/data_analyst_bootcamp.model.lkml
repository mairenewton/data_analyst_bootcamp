connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

# named_value_format: decimal_5 {
#   value_format: "#,###.#####"
# }

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {
  label: "Inventory"
  view_label: "Inventory Itemz"
#   fields: [ALL_FIELDS*, -order_items.cross_view_refs*]
  join: order_items {
    view_label: "Inventory Itemz"
    type: left_outer
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    relationship: one_to_many
    fields: [order_items.total_sales]
  }
#   join: users {
#     type: left_outer
#     sql_on: ${order_items.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
}


explore: events {}


# This explore contains multiple views
explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }
}


explore: products {}


explore: users {

  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }
}
