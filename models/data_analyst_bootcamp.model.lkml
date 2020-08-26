connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/user_order*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
 sql_trigger: SELECT max(id) from order_items;;
  max_cache_age: "1 hour"
}


datagroup: order_items_datagroup {
  sql_trigger: SELECT max(created_at) from order_items;;
  max_cache_age: "4 hours"
}

datagroup: daily_refresh {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup



### Whitespaces ####


explore: user_orders_fact_ndt {}

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup
  always_filter: {
    filters: [
      order_items.created_date: "before today"
    ]
  }

  conditionally_filter: {
    filters: [order_items.created_date: "last 2 years"]
    unless: [user_id]
  }
#   sql_always_where: ${status} = 'complete' ;;
#   sql_always_having: ${count} > 5 ;;
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

  join: user_order_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }
}


explore: products {
  persist_with: daily_refresh
}


explore: users {}
