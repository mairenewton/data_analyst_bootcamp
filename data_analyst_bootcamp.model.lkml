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

explore: inventory_items {}

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

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

}

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

explore: products {}


explore: users {
  persist_with: default
  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
    unless: [id, state]
  }

  join: order_items {
    type: left_outer
    sql:  ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
