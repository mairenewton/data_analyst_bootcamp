connection: "events_ecommerce"

# include all the views
include: "*.view"


# datagroup: data_analyst_bootcamp_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }
#
# persist_with: data_analyst_bootcamp_default_datagroup

datagroup: new_item_identifier {
  sql_trigger: SELECT Count(*) FROM ORDER_ITEMS ;;
  max_cache_age: "24 hours"
}

datagroup: new_user_identifier {
  sql_trigger: SELECT Count(*) FROM USERS ;;
  max_cache_age: "24 hours"
}

persist_with: new_item_identifier

# This explore contains multiple views
explore: order_items {
  join: users {
    view_label: "User Ordering"
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
    view_label: "User Ordering"
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
    relationship: many_to_one
  }
}


explore: products {
  #no caching for this explores
  persist_for: "0 minutes"
}


explore: explore_users {
  #Overrides with global model level persist_with
  persist_with: new_user_identifier

#   fields: [ALL_FIELDS*, -order_items.Profit_per_item]
  view_name: users
  join: order_items{
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    fields: []
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

}
