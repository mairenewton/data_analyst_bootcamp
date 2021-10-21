connection: "events_ecommerce" ## this is my comment

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: midnight_refresh {
  sql_trigger: SELECT CURRENT_DATE ;; # DB TZ
  max_cache_age: "24 hours"
}

datagroup: order_items_datagroup {
  sql_trigger: SELECT max(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

access_grant: inventory {
  user_attribute: department
  allowed_values: ["Inventory", "Marketing"]
}

# Default on model level, in case there is no perist_with on an explore level
persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup
  sql_always_where: ${order_items.returned_date} IS NULL ;;
  sql_always_having: ${order_items.sum_sale_price} > 200 ;;

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

  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

}

explore: users {
  persist_with: midnight_refresh
  access_filter:{
    field: users.state
    user_attribute: user_state
  }
  always_filter: {
    filters: [
      order_items.created_date: "Before today"
    ]
  }
  join: order_items{
    type: left_outer
    sql_on:  ${order_items.user_id} = ${users.id} ;;
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



# explore: products {}
