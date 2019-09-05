connection: "events_ecommerce"

# include all the views
include: "*.view"

datagroup: max_created_at {
  max_cache_age: "4 hour"
  sql_trigger: select count(*) from order_items;;
}

persist_with: max_created_at

# This explore contains multiple views
explore: order_items {
  join: custom_view_hehe {}

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

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


explore: products {}


explore: users {
  join: order_items {
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: custom_view_hehe {
    type: inner
    sql_on: ${custom_view_hehe.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
