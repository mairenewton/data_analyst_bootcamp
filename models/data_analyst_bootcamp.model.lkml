connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
#include: "user_orders*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
datagroup: daily_refresh {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_update {
  sql_trigger: select max(create_date) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup


### Whitespaces ####

explore: inventory_items {
  group_label: "Custom Group Name"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id}=${products.id} ;;
    relationship: many_to_one
  }
}

# This explore contains multiple views
explore: order_items {
  #sql_always_where:  ${status} = 'complete';;
  #sql_always_having: ${count} > 5 ;;
  persist_with: order_update

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


# explore: products {}


explore: users {
  persist_with: daily_refresh
  access_filter: {
    user_attribute: state
    field: users.state
  }
  join: order_items{
    fields: [order_items.total_revenue]
    type: left_outer
    sql_on: ${users.id}=${order_items.user_id};;
    relationship: one_to_many
  }
}
