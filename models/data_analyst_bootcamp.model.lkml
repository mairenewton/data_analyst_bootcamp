connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
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

  #sql_always_where: ${returned_date} is NULL;;
  sql_always_where: ${status} = 'complete' ;;
  sql_always_having: ${count} > 5000 ;;
  conditionally_filter: {
    filters: [order_items.created_date: "2 years ago"]
    unless: [users.id]
  }

  #sql_always_having: ${total_sales_price} > 200 ;;
}


# explore: products {}


explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id} =${order_items.user_id} ;;
    relationship: one_to_many
  }
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
}
