connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
datagroup: users_datagroup {
  sql_trigger: select convert_timezone('US/Pacific', current_date)::date ;;
  max_cache_age: "24 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  sql_always_where: ${order_items.status} <> 'Returned';;
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
  persist_with: users_datagroup
  group_label: "Ad Hoc Discovery"
  label: "Users Analysis"
  join: order_items {
    view_label: "Order Data"
    type: left_outer
    sql_on: ${users.id} = ${order_items.id};;
    relationship: one_to_many
  }
}
