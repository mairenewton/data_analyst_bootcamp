connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


persist_with: data_analyst_bootcamp_default_datagroup


explore: user_fact {
}

explore: users_with_pii {}

explore: inventory_items {}


explore: order_items {
  # sql_always_where: ${order_items.status} = 'Complete' ;;
  # sql_always_having: ${count} > 5000 ;;
  # persist with stuff here

#   conditionally_filter: {
#     filters: {
#       field: users.created_date
#       value: "90 days"
#     }
#     unless: [ users.id,users.state]
#   }
#
#   always_filter: {
#     filters: {
#       field: created_date
#       value: "30 days"
#     }
#   }



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
  join: order_items {
    type: left_outer
    sql_on:  ${users.id} = ${order_items.user_id} ;;
    relationship:  one_to_many
  }
}
