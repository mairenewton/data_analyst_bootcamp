connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/explores/users.explore.lkml"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM order_items;;
  max_cache_age: "1 hour"
}

datagroup: daily_refresh {
  # sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}

datagroup: default_datagroup {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}

datagroup: orders_items_datagroup {
  sql_trigger: SELECT max(created_at) from orders_item;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
# persist_for: "2 hours"

### Whitespaces ####

explore: inventory_items {
  group_label: "Custom Group Name"
  description: "This is helpful for finding inventory information"
  label: "Inventory"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

# This explore contains multiple views
explore: order_items {
#   persist_with: daily_refresh
    persist_with: orders_items_datagroup
#   sql_always_where: ${created_date} >= '2020-01-01' ;;

#   sql_always_having: ${total_revenue} >= 100 ;;

#     always_filter: {
#       filters: [order_items.created_date: "last 30 days"]
#     }

#     conditionally_filter: {
#       filters: [order_items.created_date: "last 30 days"]
#       unless: [users.state, status]
#     }

#     sql_always_where: ${status} = 'Complete' ;;

#     sql_always_having: ${count_of_orders_items} > 5 ;;

#       always_filter: {
#         filters: [order_items.created_date: "before today"]
#       }

#       conditionally_filter: {
#         filters: [order_items.created_date: "last 2 years"]
#         unless: [user_id]
#       }
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

  join: user_order_rollup {
    type: left_outer
    sql:  ${order_items.user_id} = ${user_order_rollup.user_id} ;;
    relationship: many_to_one
  }

}

# explore: order_item_ndt {}


# explore: users {}
