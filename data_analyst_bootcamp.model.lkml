connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: orders_datagroup {
  sql_trigger: SELECT max(created_date) FROM order_items ;;
  max_cache_age: "4 hours"
  description: "Triggered when new order is added"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  persist_with: orders_datagroup

  #sql_always_where: ${order_items.status} = 'Complete' ;;
  #sql_always_having: ${order_items.count}  > 5000 ;;
#   always_filter: {
#     filters: {
#       field: order_items.created_date
#       value: "last 90 days"
#     }
#     }


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

explore: bootcamp_native_table {

  view_name:  order_items
  fields: [order_items.order_id, order_items.total_sales, order_items.count]
}

explore: users {
#   conditionally_filter: {
#     filters: {
#       field: users.created_date
#       value: "90 days"
#     }
#     unless: [users.id, users.state]
#   }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship:  one_to_many
  }
  join: order_derived_info {
    type:  left_outer
    sql_on: ${order_items.user_id} = ${order_derived_info.user_id} ;;
    relationship: one_to_one
  }


}
