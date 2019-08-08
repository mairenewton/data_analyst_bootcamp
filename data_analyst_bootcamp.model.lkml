connection: "events_ecommerce"

# include all the views
include: "*.view"

datagroup: new_order_items_identifier {
  sql_trigger:  select count(*) from order_items;;
  max_cache_age: "24 hours"
}

datagroup: new_user_identifier {
  sql_trigger:  select count(*) from users;;
  max_cache_age: "24 hours"
}

persist_with: new_order_items_identifier

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


  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: user_order_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
    relationship: many_to_one
  }
}


explore: products {}


explore: users {}

explore: explore_users {
  persist_with: new_order_items_identifier
  #fields: [ALL_FIELDS*,-order_items.profit,-order_items.total_profit]
  view_name: users
  join: order_items {
    type: left_outer
    sql_on: ${users.id}=${order_items.order_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    fields: []
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}
