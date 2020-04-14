connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  # sql_trigger: current date ;; # - would refresh cache daily based on DB date
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: Select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items

  #sql_always_where: ${order_items.status} = 'Complete' ;;
  #sql_always_having:${order_items.count} > 5000 ;;
  #sql_always_where: ${returned_date} is null ;; #stopping returned orders showing example
  #sql_always_having:${order_items.count} > 200 ;; - example only, will restrict results

#   conditionally_filter: {
#     filters: [ order_items.created_date: "2 years"]
#     unless: [users.id] #now it's conditionally required unless we query on users.id
#   }

  always_filter: {
    filters: {
      field: order_items.created_date
      value: "30 days"
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


explore: products {}


explore: users {
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "90 days"
    }
    unless: [users.id,users.state]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: exercise_1 {
    type: left_outer
    sql_on: ${users.id} = ${exercise_1.user_id} ;;
    relationship: one_to_many
  }
}

# explore: users_two {
#   from: "users"
#   join: order_items {
#     type: left_outer
#     relationship:  one_to_many
#     sql_on: ${users_two.id} = ${order_items.user_id} ;;
#   }
# }
