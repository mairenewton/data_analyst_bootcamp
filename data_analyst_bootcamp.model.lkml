connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


datagroup: order_items {
  max_cache_age: "4 hours"
  sql_trigger: SELECT MAX(created_date) FROM order_items ;;
}


explore: order_items {
  persist_with: order_items
  always_filter: {
    filters: {
      field: created_date
      value: "30 days ago"
    }
  }
  sql_always_where: ${status} = 'complete' ;;
  sql_always_having: ${ordercount}>50 ;;
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
conditionally_filter: {
  filters: {
    field: created_date
    value: "90 Days ago"
  }
  unless: [users.id,users.state]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

}
explore: inventory_items {}
