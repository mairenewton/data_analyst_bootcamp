connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

datagroup: order_items {
  sql_trigger:  max(created_time) FROM order_items;;
  max_cache_age: "4 hours"
}

# This explore contains multiple views
explore: order_items {

persist_with: order_items


  conditionally_filter: {
    filters: [inventory_items.created_year: "last 2 years"]
    unless: [users.id]
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

explore: users {
  persist_with: data_analyst_bootcamp_default_datagroup
  join: order_items {
    type: left_outer
    sql_on: ${users.id}= ${order_items.user_id} =  ;;
    relationship: one_to_many
  }
}
# explore: products {}
