connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: monthly_datagroup {
  sql_trigger: select date_trunc('month', current_date) ;;
  max_cache_age: "672 hours" # 28 days
}

datagroup: four_hour_datagroup {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: four_hour_datagroup

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

  conditionally_filter: {
    filters: {
      field: order_items.created_date
      value: "last 2 years"
    }

    unless: [users.id]
  }
}


explore: products {}


explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  always_filter: {
    filters: {
      field: order_items.created_date
      value: "before today"
    }
  }
}
