connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: default_dg {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items
conditionally_filter: {
  filters: [order_items.created_date: "last 2 years"]
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
  fields: [ALL_FIELDS*,-order_items.profit]
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: user_facts {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }
}


explore: inventory_items {
  join: product_analysis {
    type: left_outer
    sql_on: ${inventory_items.product_sku} = ${product_analysis.product_sku} ;;
    relationship: one_to_one
  }
}
