connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: defatult_user_datagroup {
  sql_trigger: select cast(now() as date)  ;;
  max_cache_age: "24 hour"
}

datagroup: order_items_datagroup {
  sql_trigger: select max(completed_at) from public.order_items  ;;
  max_cache_age: "4 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup
  always_filter: {
    filters: [order_items.created_date: "last 30 days"]
  }
  # conditionally_filter: {
  #   filters: [order_items.created_date: "last 30 days"]
  #   unless: [user_id]
  # }
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
}

explore: users {
  persist_with: defatult_user_datagroup
  conditionally_filter: {
    filters: [users.created_date: "last 90 days"]
    unless: [id,state]
  }
}

# explore: products {}
