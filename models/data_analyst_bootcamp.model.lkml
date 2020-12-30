connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
# added comment

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


datagroup: midnight {
  sql_trigger: CURRENT_DATE ;;
  max_cache_age: "24 hour"
}

datagroup: order_items_datagroup {
  sql_trigger: MAX(${TABLE}.created_at) ;;
  max_cache_age: "4 hour"
}

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup
  always_filter: {
    filters: [order_items.created_date: "30 days"]
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


explore: users {
  persist_with: midnight
  always_filter: {
    filters: [order_items.created_date: "before today"]
  }
  join: order_items {
    type:  left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_many
  }
}


# explore: products {}
