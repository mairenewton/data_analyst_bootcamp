connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
# sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"}

persist_with: data_analyst_bootcamp_default_datagroup


###change
##adding comments
### Whitespaces ####

 explore: brand_order_facts_ndt {}



# This explore contains multiple views
explore: order_items {

  group_label: "CNA Training"
  label: "Orders"
  description: "Use this for the CNA developer training"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
#    view_label: "Products & Inventory"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
#    view_label: "Products & Inventory"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
# conditionally_filter: {
#     filters: [order_items.created_date: "last 2 years"]
#     unless: [users.id]
#   }
  conditionally_filter: {
    filters: [order_items.created_date: "last 90 days"]
    unless: [users.id, users.state]
  }
group_label: "CNA Training"
description: "This is for the user and order details"
join: order_items {
  type: left_outer
  sql_on: ${users.id} = ${order_items.user_id} ;;
  relationship: one_to_many
}
join: inventory_items {
  view_label: "Order Items"
  type: left_outer
  sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  relationship: many_to_one
  fields: [inventory_items.cost]
}

}

# explore: products {
#   group_label: "Advanced Data Analyst Bootcamp"

# }
