connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
# explore:  order_items_v2 {
#   from: order_items
#   fields: [ALL_FIELDS*, -order_items_v2.total_sales_new_users, -order_items_v2.profit]

# }

explore: order_items {
  label: "Order Items Brendan"
  group_label: "Brendan's Group"
  description: "This is a description"
  join: users {
    view_label: "Users Brendan"
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

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  # sql_always_having: ${total_sales} > 1000 ;;
  # sql_always_where: ${users.state}='Texas' ;;

  # always_filter: {
  #   filters: [users.state: "New York"]
  #   filters: [order_items.created_date: "30 days"]
  # }

  conditionally_filter: {
    filters: [users.state: "New York"]
    unless: [users.city]
  }

}


# explore: products {}
