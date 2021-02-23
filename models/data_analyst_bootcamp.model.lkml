connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change
#Another Change
### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  sql_always_where: ${returned_date} is null ;;
  sql_always_having: ${total_Sales} > 200 ;;
  always_filter: {
    filters: [order_items.status: "Complete", order_items.count: ">5"]
  }
  conditionally_filter: {
    filters: [order_items.created_date: "last 2 years"]
    unless: [user_id]
  }
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
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# user explore
explore: users {
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
  conditionally_filter: {
    filters: [users.created_date: "last 90 days"]
    unless: [users.id, users.state]
  }
  join: order_items {
    type:  left_outer
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
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

# explore: products {}
