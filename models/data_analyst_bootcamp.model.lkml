connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/views/derived_tables/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger:  SELECT MAX(completed_at) from etl_jobs ;;
  max_cache_age: "1 hour"
}

datagroup: daily {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "11 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup

# This explore contains multiple views
explore: order_items {

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

  join: user_order_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_facts.user_id} ;;
    relationship: many_to_one
  }
}

  explore: all_products {
    persist_with: daily
    sql_always_where: ${products.department} = 'Men' ;;
    view_name: products

    join: inventory_items {
      type: left_outer
      relationship: one_to_many
      sql_on: ${products.id} = ${inventory_items.product_id}  ;;
    }

    join: order_items {
      type: left_outer
      sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
      relationship: one_to_many
    }
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
