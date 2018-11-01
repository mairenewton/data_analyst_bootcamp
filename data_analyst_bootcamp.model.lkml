connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: midnight {
  sql_trigger: select CURRENT_DATE ;;
  max_cache_age: "24 hours"
}



persist_with: data_analyst_bootcamp_default_datagroup




explore: inventory_items {}
#

explore: order_items {
#   sql_always_where: ${order_items.status} = 'complete' ;;
#   sql_always_having: ${order_items.count} > 5 ;;
  conditionally_filter: {
    filters: {
      field: order_items.created_date
      value: "last 2 years"
    }

    unless: [users.id]
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


explore: users {
#   always_filter: {
#    filters: {
#     field: order_items.created_date
#     value: "before today"
#    }
#   }

conditionally_filter: {
  filters: {
    field: users.created_date
    value: "last 90 days"
  }
  unless: [users.id, users.state]
}

persist_with: midnight


  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
