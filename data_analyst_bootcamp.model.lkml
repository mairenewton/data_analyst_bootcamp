connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views!
explore: order_items {
  sql_always_where:  ${status} = "Complete" ;;
  sql_always_having:  ${count} > 5000  ;;
  always_filter: {
    filters: {
      field:  created_date
      value: "last 30 days"
    }
  }
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
      }
    unless: [users.id, users.state]
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
}

datagroup: order_items {
  max_cache_age: "4 hours"
  sql_trigger: select max(created_at) from order_items;;
}

explore: products {}


explore: users {
  join: order_items{
    type:  left_outer
    sql_on:  ${users.id} = ${order_items.user_id};;
    relationship: many_to_one
  }
}
