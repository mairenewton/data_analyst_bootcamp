connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items_datagroup {
  sql_trigger: SELECT count(*) from public.order_items ;;
  max_cache_age: "4 hours"
}

#persist_with: data_analyst_bootcamp_default_datagroup

persist_with:  order_items_datagroup

explore: order_items {
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


explore: products {}


explore: users {
  description: "Use this explore to any user information"
  join: order_items {
    type:  left_outer
    sql_on:  ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: events {
  persist_with: data_analyst_bootcamp_default_datagroup
  #group_label: "Data Analyst Bootcamp events"
  join: users {
    type: left_outer
    sql_on:  ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}


explore: inventory_items {
label: "Inventory"
description: "use this explore for viewing detailed inventory and product information"
  join: products {
    type:  left_outer
    sql_on:  ${inventory_items.product_id} = ${products.id} ;;
    relationship:  many_to_one
  }
}
