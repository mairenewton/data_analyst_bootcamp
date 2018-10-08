connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_trig {
  sql_trigger: select MAX(created_timestamp) from order_items ;;
}



persist_with: data_analyst_bootcamp_default_datagroup


explore: users_data {
  from: users
  join: order_items {
    type: left_outer
    sql_on: ${users_data.id} = ${order_items.user_id};;
    relationship: one_to_many
  }
}

explore: inventory_items {}
#

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
  persist_with: default
}
