connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/views/Derived_Tables/*.view"

#datagroup: data_analyst_bootcamp_default_datagroup {
#  # sql_trigger: SELECT MAX(id) FROM etl_log;;
#  max_cache_age: "1 hour"
#}

#persist_with: data_analyst_bootcamp_default_datagroup



datagroup: daily_datagroup {
  max_cache_age: "24 hours"
  sql_trigger: select current_date ;;
}

persist_with: daily_datagroup

datagroup: order_items_datagroup {
  max_cache_age: "4 hours"
  sql_trigger: select select max(created_at) from order_items ;;
}


#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
 # sql_always_where: ${returned_date} is null and ${status} = 'Complete' ;;
#  sql_always_having: ${Total_Sales} > 200 and ${count} > 5;;
#  conditionally_filter: {
#    filters: [order_items.created_year: "2 years"]
#    unless: [users.id]
sql_always_where: ${created_date} >= current_date-30 ;;

  persist_with: order_items_datagroup


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


# explore: products {}


explore: users {
  persist_with: daily_datagroup
  fields: [ALL_FIELDS*,-order_items.profit]
  #sql_always_where: ${created_raw} < current_date ;;
  conditionally_filter: {
    filters: [users.created_date: "last 90 days"]
    unless: [users.id,state]
}

  join: order_items {
    type: left_outer
    sql_on:  ${users.id} = ${order_items.user_id};;
    relationship: one_to_many
  }
  }
