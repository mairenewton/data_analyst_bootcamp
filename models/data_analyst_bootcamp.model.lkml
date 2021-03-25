connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
   sql_trigger: SELECT MAX(id) FROM etl_log;;
  #max_cache_age: "1 hour"
}

# datagroup: data_analyst_bootcamp2 {
#   sql_trigger: SELECT MAX(id) FROM etl_log;;
#   max_cache_age: "12 hour"
# }

datagroup: default_datagroup_midnight {
  sql_trigger: SELECT current_date ;;
  max_cache_age: "24 hours"
}

datagroup:  order_items_datagroup{
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

datagroup: default {

  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup


  # always_filter: {
  #   filters: [status: "Complete", users.country: "USA"]
  # }
  # conditionally_filter: {
  #   filters: [created_date: "1 month"]
  #   unless: [users.id, users.state]
  # }
  # sql_always_where: ${order_items.returned_date} IS NULL ;;
  # sql_always_having: ${order_items.total_sales} > 200  ;;
  # sql_always_where: ${order_items.status} = "Complete" ;;
  # sql_always_having: ${order_items.orders} > 5 ;;
  # always_filter: {
  #   filters: [orders: ">5"]
  # }

  # conditionally_filter: {
  #   filters: [order_items.created_date: "last 2 years"]
  #   unless: [users.id]
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

  join: ldt_order_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${ldt_order_facts.order_id} ;;
  }

  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
  }

  join: ndt_user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${ndt_user_facts.user_id} ;;
    relationship: many_to_one
  }

  join: inventory_facts {
    type: left_outer
    sql_on: ${products.sku} = ${inventory_facts.product_sku} ;;
    relationship: many_to_one
  }

  join: brand_order_facts_ndt {
    type: left_outer
    sql_on: ${products.brand} = ${brand_order_facts_ndt.brand} ;;
    relationship: many_to_one
  }
}

explore: users {
    persist_with: default_datagroup_midnight

  # always_filter: {
  #   filters: [users.created_date: "before today"]
  # }

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    fields: []
  }


}

explore: events {}

explore: events_rollup {}
# explore: products {}
