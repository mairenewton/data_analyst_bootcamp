connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: default_datagroup {
  sql_trigger: SELECT CURRENT_DATE ;;
  max_cache_age: "24 hour"
}

datagroup: order_items_datagroup {
  sql_trigger: SELECT MAX(created_at) FROM order_items  ;;
  max_cache_age: "4 hours"
}
#persist_with: default_datagroup

access_grant: is_pii_viewer {
  user_attribute: is_pii_viewer
  allowed_values: ["Yes"]
}

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  persist_with: order_items_datagroup

  #sql_always_where: ${order_items.returned_date} IS NULL ;;
  #sql_always_having: ${order_items.total_sales} > 200 ;;
  sql_always_where: ${order_items.status} = 'Complete' ;;
  #sql_always_having: ${order_items.count} > 5 ;;

  always_filter: {
    filters: [order_items.created_date: "last 30 days"]
  }

  #conditionally_filter: {
  #  filters: [order_items.created_date: "last 2 years"]
  #  unless: [users.id]
  #}

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

  join: order_facts {
    type: left_outer
    sql_on: ${inventory_items.product_sku} = ${order_facts.product_sku} ;;
    relationship: many_to_one
  }

  join: brand_order_facts_ndt{
    type: left_outer
    sql_on: ${products.brand} = ${brand_order_facts_ndt.brand} ;;
    relationship: many_to_one
  }
}


explore: inventory_items {}


explore: users {

  persist_with: default_datagroup

  #always_filter: {
  #  filters: [order_items.created_date: "before today"]
  #}

  conditionally_filter: {
    filters: [users.created_date: "last 90 days"]
    unless: [users.id,users.state]
  }

  access_filter: {
    field: users.state
    user_attribute: state
  }
  join: user_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: brand_order_facts_ndt {}
