connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  sql_always_where: ${status} = 'complete' ;;
  #sql_always_where: ${returned_date} is null ;; #stopping returned orders showing example
  #sql_always_having:${order_items.count} > 200 ;; - example only, will restrict results
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
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

# explore: users_two {
#   from: "users"
#   join: order_items {
#     type: left_outer
#     relationship:  one_to_many
#     sql_on: ${users_two.id} = ${order_items.user_id} ;;
#   }
# }
