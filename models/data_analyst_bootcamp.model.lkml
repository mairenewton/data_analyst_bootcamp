connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: default1 {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default2 {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}

datagroup: default_users {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: default_order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}


#persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: default_order_items
  always_filter: {
    filters: [order_items.created_date: "last 30 days"]
  }
  # always_filter: {
  #   filters: [order_items.created_date: "before today"]
  # }
  # sql_always_where: ${returned_date} is NULL ;;
  # sql_always_having: ${email_total_sales} > 200 ;;
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

# users explore custom
explore: users {
  persist_with: default_users
  conditionally_filter: {
    filters: [inventory_items.created_date: "past 90 days"]
    unless: [users.id, users.state]
  }
  # conditionally_filter: {
  #   filters: [order_items.created_date: "last 2 years"]
  # }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
  type: left_outer
  sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  relationship: many_to_one
  fields: []
  }
  join: user_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id};;
    relationship: one_to_many
  }
}










# explore: products {}
