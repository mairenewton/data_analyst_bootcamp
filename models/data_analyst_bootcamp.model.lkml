connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/views/*/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger:  SELECT MAX(completed_at) from etl_jobs ;;
  max_cache_age: "1 hour"
}

datagroup: default {
  max_cache_age: "24 hours"
  sql_trigger: SELECT current_date ;;
}

datagroup: order_items {
  max_cache_age: "4 hours"
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
}

persist_with: data_analyst_bootcamp_default_datagroup

# This explore contains multiple views
explore: order_items {
  persist_with:  order_items
  description: "this provide more info about the explore"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
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

  join: ndt_order_fcts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${ndt_order_fcts.order_id} ;;
    relationship: many_to_one
  }
}

  explore: users {
    persist_with:  default
    join: order_items {
      type: left_outer
      relationship: one_to_many
      sql_on: ${users.id} = ${order_items.user_id} ;;
      }
    join: inventory_items {
      type: left_outer
      relationship: many_to_one
      sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    }
    join: user_facts {
      type: left_outer
      relationship: one_to_one
      sql_on: ${users.id} = ${user_facts.user_id} ;;
    }
  }

# This Explore only contains a single view
# explore: products {}

















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
