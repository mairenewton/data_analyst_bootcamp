connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: daily_refresh {
  sql_trigger: SELECT CURRENT_DATE ;;
  max_cache_age: "24 hours"
}

datagroup: order_items {
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

explore: user_order_facts {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items
  # conditionally_filter: {filters: [order_items.created_date: "30 days"]
  # unless:[status]} ## unless is for default filter, when no other is used ## filter the users can maually remove
  # sql_always_where: ${created_date} >= '2012-01-01' ;; - where filter on raw data
  # sql_always_having: ${count} > 5 ;;
  ## sql_always_where: ${users.city} != 'London' ;; -can cause performance issues, not cool, instead in sql_on

  ## having and where, total_sales is measure -> having
  #sql_always_where: ${status} != 'Returned';;
  #sql_always_having: ${total_sales} > 200 ;;

  sql_always_where: ${status} = 'Complete' ;;
  sql_always_having: ${count} > 5000 ;;

  conditionally_filter: {filters: [order_items.created_date: "2 years"]
    unless:[users.id]}

  #always_filter: {filters:[created_date: "30 days"]}

  label: "The Order Items Explore"
  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id};;
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
}

explore: user_facts {
  join: users {
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_facts.user_id} ;;
  }
}

explore: users {
  persist_with: daily_refresh
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
  conditionally_filter: {
    filters: [created_date: "90days"]
    unless: [id, state]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id};;
    relationship: one_to_many
}
}

 explore: products {}


# explore: users {}
