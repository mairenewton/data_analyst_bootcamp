connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  # max_cache_age: "1 hour"
  sql_trigger: SELECT CURDATE();;
  max_cache_age: "24 hours"
}


datagroup: order_items_datagroup {
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  #sql_always_where: ${order_items.returned_date} IS NULL;;
  #sql_always_having: ${order_items.total_sales} > 200 ;;
  persist_with: order_items_datagroup

  always_filter: {
    filters: [order_items.created_date: "before today"]
  }

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


# explore: products {}
explore: users {
  persist_with: default_datagroup
  conditionally_filter: {
    filters: [order_items.created_date: "last 2 years"]
    unless: [users.id]
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id};;
    relationship: one_to_many
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    fields: []
  }
}
