connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: data_analyst_bootcamp_users {
  sql_trigger: SELECT current_day();;
  max_cache_age: "24 hours"
}

datagroup: data_analyst_order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change
#Another Change
### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  sql_always_where: ${status} = 'Complete' ;;
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: sql_runner_query {
    type: left_outer
    sql_on:  ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_one
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

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {persist_with: data_analyst_bootcamp_users}
# explore: products {}
