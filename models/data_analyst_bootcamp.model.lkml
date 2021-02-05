connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
# added comment



datagroup: users_update {
  sql_trigger: SELECT CURRENT_DATE  ;;
  max_cache_age: "24 hours"
}

persist_with: users_update

# order items datagroup:
datagroup: order_items_update {
  sql_trigger: SELECT max(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

###change

### Whitespaces ####

# explore: inventory_items {}

explore: users {
  persist_with: users_update
}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_update



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

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_user_summary {
    sql_on: ${order_items.order_id} = ${order_user_summary.order_id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: user_facts {
    sql_on: ${order_items.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: product_facts {
    sql_on: ${products.sku} = ${product_facts.product_sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: traffic_source_facts {
    sql_on: ${users.traffic_source} = ${traffic_source_facts.traffic_source} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: order_facts {
    sql_on: ${order_facts.order_id} = ${order_items.order_id} ;;
    relationship: one_to_one
  }

}


# explore: products {}
