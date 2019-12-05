connection: "events_ecommerce"

# include all the views
include: "*.view"


#datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
#  max_cache_age: "1 hour"
#}

datagroup: users {
  sql_trigger: select max(created_at) from public.users ;;
  max_cache_age: "4 hours"
}

persist_with: users

explore: inventory_items {}

# This explore contains multiple views!
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

explore: user_order_summary {
  view_label: "Users"
  join: users {
    type: left_outer
    sql_on: ${user_order_summary.users_id}=${users.id} ;;
    relationship: many_to_one
  }
}

explore: user_order_summary_ndt {
  view_label: "Users"
  join: users {
    type: left_outer
    sql_on: ${user_order_summary_ndt.user_id}=${users.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${products.id}= ${user_order_summary_ndt.inventory_item_id};;
    relationship: many_to_one
  }
}


explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.users_id}=users.id
    ;;
    relationship: many_to_one
  }
}

explore: products {}



explore: users {}


explore: events {}
