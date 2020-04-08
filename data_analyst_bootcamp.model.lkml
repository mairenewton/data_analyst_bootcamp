connection: "events_ecommerce"
persist_with: default

# include all the views
include: "*.view"

# include all the dashboards
#include: "*.dashboard"

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

explore: order_items {
#   sql_always_where: ${order_items.returned_date} IS NULL ;;
#   sql_always_having: ${order_items.total_sales} > 200 ;;
#   sql_always_where: ${order_items.status} = ‘complete’ ;;
#   sql_always_having: ${order_items.count} > 5000 ;;

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

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: users_explore {
    type: left_outer
    sql_on: ${users_explore.id} = ${users.id};;
    relationship: many_to_one
  }
}

# explore: events {
#   join: event_session_facts {
#     type: left_outer
#     sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
#     relationship: many_to_one
#   }
#   join: event_session_funnel {
#     type: left_outer
#     sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
#     relationship: many_to_one
#   }
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  label: "Users, Orders, and Inventory"
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
}

explore: user_measures {}
explore: users_explore {}
explore: training1 {}
