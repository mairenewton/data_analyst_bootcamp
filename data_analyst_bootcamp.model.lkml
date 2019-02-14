connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
persist_with: data_analyst_bootcamp_default_datagroup

datagroup: order_items {
  sql_trigger: SELECT max(created_at) FROM order_itmes;;
  max_cache_age: "4 hours"
}

explore: inventory_items {}
#

explore: order_items {
persist_with: order_items
  always_filter: {
    filters: {
      field: created_date
      value: "last 30 days"
    }
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

  join: order_items_test {
    type: left_outer
    sql_on: ${order_items_test.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

}

explore: products {}


explore: users {
  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
    unless: [users.id,order_items.user_id]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: order_items_test {}

explore: high_level_order {}
