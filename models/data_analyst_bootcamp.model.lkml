connection: "events_ecommerce"

# include all the views
include: "/views/**/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "24 hour"
  sql_trigger: SELECT CURRENT_DATE ;;
}

persist_with: data_analyst_bootcamp_default_datagroup


#This explore contains multiple views
explore: order_items {
  group_label: "This snazzy topic"
  description: "this provide more info about the explore"

  #sql_always_where: ${created_date} >= DATE('2021-01-01') ;;

  # always_filter: {
  #   filters: [
  #     order_items.created_date: "3 months"
  #   ]
  # }

  # conditionally_filter: {
  #   filters: [order_items.created_date: "1 month"]
  #   unless: [status]
  # }

  query: total_sales_this_year {
    dimensions: [order_items.created_date]
    measures: [order_items.total_sales]
    filters: [order_items.created_date: "1 year"]
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
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
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: order_facts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_facts.order_id} ;;
    relationship: many_to_one
  }

}

  explore: users {
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
  }


explore: +order_items {
  aggregate_table: rollup__status {
    query: {
      dimensions: [status]
      measures: [total_sales]
      timezone: "America/New_York"
    }

    materialization: {
      datagroup_trigger: data_analyst_bootcamp_default_datagroup
    }
  }
}



explore: order_facts {}
















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
