connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

datagroup: user_dg {
  sql_trigger: select current_date();;
  max_cache_age: "24 hours"
}

persist_with: user_dg

datagroup: order_items_dg {
  sql_trigger: select max(created_at_timestamp) from order_items;;
  max_cache_age: "4 hours"
}

persist_with: order_items_dg

#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  sql_always_where: ${status} = 'Complete';;
  sql_always_having: ${count} > 5 ;;


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

explore: users {
  persist_with: user_dg

  fields: [ALL_FIELDS*,-order_items.profit]

  sql_always_where: ${order_items.created_raw} < current_date;;
  conditionally_filter: {
    filters: [order_items.created_date: "2 years"]
    unless: [users.id]
  }

  join: order_items {
    type:  left_outer
    sql_on: ${users.id} = ${order_items.user_id};;
    relationship: one_to_many
  }
  }
# explore: products {}
