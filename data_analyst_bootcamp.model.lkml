connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
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
  always_filter: {
    filters: {
      field: status
      value: "Complete"
    }
    filters: {
      field: inventory_items.count
      value: ">5000"
    }
    filters: {
      field: created_date
      value: "last 30 days"
    }
  }
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
    }
    unless: [users.id,users.state]
  }

}

#explore: users_and_orders {
#  from: users
#  join: order_items {
#    type: left_outer
#    sql_on: ${users_and_orders.id} = ${order_items.user_id} ;;
#    relationship: one_to_many
#  }
#}

explore: products {}


explore: users {}
