connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  #sql_always_where: ${status} != "Cancelled" ;;
  # sql_always_having: ${count} > 1 ;;
  always_filter: {
    filters: [order_items.status: "-Cancelled"]
  }
  # conditionally_filter: {
  #   filters: [order_items.status: "-Cancelled"]
  #   unless: [created_date]
  # }
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


explore: products {
  label: "stuff"
  group_label: "1. Other stuff"
  description: "products"
  join: inventory_items {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
