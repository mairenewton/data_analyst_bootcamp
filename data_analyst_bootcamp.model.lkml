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

  join: order_facts_ndt{
    type: inner
    sql_on:  ${order_items.order_id} = ${order_facts_ndt.order_id} ;;
    relationship:  one_to_one
  }
}


explore: products {}


explore: users {
  join: order_items {
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: sql_subquery_training {
  join: users {
    type:  left_outer
    sql_on: ${sql_subquery_training.user_id} = ${users.id};;
    relationship: one_to_one
  }
}
