connection: "events_ecommerce" ## this is my comment

# include all the views
include: "/views/*.view"
include: "/derived/derived_example.view.lkml"
include: "/derived/user_facts.view.lkml"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default {
  sql_trigger: select current_date;;
  max_cache_age: "24 hours"
}

datagroup: order_items_dg {
  sql_trigger: select max(created_at}) from order_items ;;
  max_cache_age: "4 hours"

}


persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_dg
  # sql_always_where: ${returned_raw} IS NULL ;;
  # sql_always_having: ${order_items.total_sales_price} > 200 ;;
  # sql_always_where: ${order_items.status} = "Complete" ;;
  # sql_always_having: ${order_items.count} ;;
  conditionally_filter: {
    filters: [users.created_date: "2 years ago"]
    unless: [users.id]
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

  join: distribution_centers {
    required_access_grants: [inventory]
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }



  # query: order_status_by_date{
  #   dimensions: [order_items.created_date, order_items.status]
  #   measures: [order_items.total_revenue]

  #   filters: [order_items.created_date: "last 30 days"]
  # }

  # query: orders_by_date{
  #   dimensions: [order_items.created_date]
  #   measures: [order_items.total_revenue]
  #   filters: [order_items.created_date: "last 30 days"]
  # }
}

access_grant: inventory {
  user_attribute: accessible_departments
  allowed_values: ["Inventory"]
}

access_grant: is_pii_viewer {
  user_attribute: is_pii_viewer
  allowed_values: ["Yes"]
}

explore: users {
  persist_with: default
  fields: [ALL_FIELDS*,-order_items.profit]
  always_filter: {
    filters: [users.created_date: "before today"]
    }
  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }
  access_filter: {
    field: users.state
    user_attribute: state
  }
}

explore: user_facts {
  # persist_with: default
  join: users {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}



# explore: products {}
