connection: "events_ecommerce" ## this is my comment

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


datagroup: last_order_item {
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

datagroup: midnight_refresh {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}
# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: last_order_item
  sql_always_where: ${order_items.returned_date} is null ;;
  sql_always_having: ${total_sales} > 200 ;;
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
  persist_with: midnight_refresh
  access_filter: {
    field: users.state
    user_attribute: state
  }
  always_filter:  {
    filters: [order_items.created_date : "before today"]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: user_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }
}


# explore: products {}
