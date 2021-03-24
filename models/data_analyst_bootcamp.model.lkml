connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

##triggers at midnight with date change
datagroup: default_dg {
 sql_trigger: SELECT current_date;;
  max_cache_age: "24 hour"
}

## triggered anytime max created_at changes
datagroup: order_item_dg {
  sql_trigger: SELECT MAX(created_at) FROM order_items;;
  max_cache_age: "4 hour"
}

persist_with: default_dg
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
persist_with: order_item_dg
  # sql_always_where: ${order_items.status} = 'Complete';;
  # sql_always_having: ${counts_of_orders} > 5;;
  conditionally_filter: {
    filters: [order_items.created_date: "last 2 years"]
    unless: [users.id]
  }
  # group_label: "LookML Developer Bootcamp"
  # label: "Orders"
  # description: "This is used for order details"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "Inventory"
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


explore: users {
  persist_with: default_dg
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
  join: inventory_items {
    type: left_outer
    sql: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    fields: []
  }
}






# explore: products {}
