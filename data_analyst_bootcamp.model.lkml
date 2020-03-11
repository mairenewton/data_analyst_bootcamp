connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}


persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

explore: order_facts_v2 {}

explore: events {}

# This explore contains multiple views
explore: order_items {
  always_filter: {
    filters: {
      field: order_items.created_date
      value: "last 30 days"
    }
  }

  label: "Order Items"
  description: "This is used for..."
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
 #   fields: []
  }

  join: inventory_items {
    view_label: "Inventory"
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
#  persist_with: default
}


explore: users {
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
    }
    unless: [users.id, users.state]
  }
  }
