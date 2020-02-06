connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default_group {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

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
  sql_always_where: ${returned_date} IS NULL AND ${status} IS 'Complete';;
  sql_always_having: ${total_sales} > 200 AND ${count} > 5000;;
  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 2 years"
    }
    unless: [users.id]
  }
  always_filter: {
    filters: {
      field: created_date
      value: "before today"
    }
  }
}


explore: products {}


explore: users {
  persist_with: default_group
  join: order_items {
    type: left_outer
    sql_on:  ${users.id} = $(orde_items.user_id} ;;
    relationship: one_to_many
  }
  sql_always_where: ${created_date} < SYSDATE ;;
}
