connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

# datagroup: users_datagroup {
#   sql_trigger: SELECT COUNT DISTINCT(user_id) from users ;;
# }

persist_with: data_analyst_bootcamp_default_datagroup


explore: inventory_items {}


explore: order_items {
  # label: "New Explore Title"
  # group_label: "New Explore Grouping"
  # description: "Explore description"
  join: users {
    # view_label: "Users View Label"
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


# explore: users {
#   persist_with: users_datagroup
#   join: order_items {
#     type: left_outer
#     relationship: one_to_many
#     sql_on: ${users.id}=${order_items.user_id} ;;
#   }

# }
