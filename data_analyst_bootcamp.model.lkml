connection: "events_ecommerce"

# include all the views
include: "*.view"


# datagroup: data_analyst_bootcamp_default_datagroup {
#   sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "1 hour"
# }



datagroup: default_datagroup {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

# persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  # persist_with: default_datagroup
  persist_for: "2 hours"
  sql_always_where: ${returned_date} is null ;;
  sql_always_having: ${total_sales} > 200 ;;
  # always_filter: {
  #   filters: [users.age: "12"]
  # }
  # conditionally_filter: {
  #   filters: [users.age: "12"]
  #   unless: [users.city]
  # }
  # fields: [users.age_tier]
  description: "Use this Explore for X, Y, Z"
  join: users {
    sql_on: ${order_items.user_id} = ${users.id} ;;
    type: left_outer
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


explore: products {
  persist_with: default_datagroup
}

explore: lifetime_orders {}


explore: users {
  label: "Test"
  persist_with: default_datagroup
  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }
  join: lifetime_orders {
    type: left_outer
    sql_on: ${lifetime_orders.user_id} = ${users.id} ;;
    relationship: one_to_many
  }
}
