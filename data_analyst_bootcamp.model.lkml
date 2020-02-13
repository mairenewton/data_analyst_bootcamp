connection: "events_ecommerce"

datagroup: daily {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

# include all the views
include: "*.view"

#add a comment

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
##  sql_always_where: ${status} = 'complete' ;;
##  sql_always_having: ${order_count} > 5000 ;;
##
##  always_filter: {
##    filters: {
##      field: created_date
##      value: "last 30 days"
##    }
##  }

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

  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
  }

}


explore: products {}




explore: users {

  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
    unless: [users.id, users.state]
  }

  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
