connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
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
}


explore: products {}


explore: users {
  join: by_user_dt {
  relationship: one_to_one
  type: left_outer
  sql_on: ${users.id} = ${by_user_dt.id} ;;
  }

  join: order_items {
    type: left_outer
    relationship: many_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: by_order {
    relationship: many_to_one
    type: left_outer
    sql_on: ${order_items.order_id} = ${by_order.order_id} ;;
  }

}
