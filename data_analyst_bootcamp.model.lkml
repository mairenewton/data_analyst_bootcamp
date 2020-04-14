connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

explore: inventory_items {

  join: product_inventory_facts_sdt {
    type: inner
    sql_on: ${inventory_items.product_sku} = ${product_inventory_facts_sdt.product_sku} ;;
    relationship: many_to_one
  }

}

# This explore contains multiple views
explore: order_items {

  persist_with: order_items

#   sql_always_where: ${order_items.returned_date} IS NULL ;;
#   sql_always_having: ${order_items.count} > 200 ;;
#   sql_always_where: ${order_items.status} = 'Complete' ;;
#   sql_always_having: ${order_items.count} > 5000 ;;


#   conditionally_filter: {
#     filters: {
#       field: order_items.created_date
#       value: "2 years"
#     }
#     unless: [users.id]
#   }

#   always_filter: {
#     filters: {
#       field: order_items.created_date
#       value: "30 days"
#     }
#   }

  join: average_lifetime_values {
    type: left_outer
    sql_on: ${order_items.user_id} = ${average_lifetime_values.user_id};;
    relationship: many_to_one
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


explore: products {}

# explore: average_lifetime_values {}

explore: users {

#   always_filter: {
#     filters: {
#       field: order_items.created_date
#       value: "before today"
#     }
#   }
#

#   conditionally_filter: {
#     filters: {
#       field: users.created_date
#       value: "90 days"
#     }
#     unless: [users.id, users.state]
#   }

join: average_lifetime_values {
  type: left_outer
  sql_on: ${users.id} = ${average_lifetime_values.user_id};;
  relationship: one_to_one
}

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
