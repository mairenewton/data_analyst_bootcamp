connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: count_order_items {
  sql_trigger: select count(*) from order_items;;
}

persist_with: data_analyst_bootcamp_default_datagroup

datagroup:max_created_4_hours{
  sql_trigger: select max(created_at) from order_items;;
  max_cache_age: "4 hours"
}
# This explore contains multiple views
explore: order_items {
  persist_with: max_created_4_hours
#   always_join: [users]

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_orders_fact {
    type: inner
    sql_on: ${user_orders_fact.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_orders_fact_ndt {
    type: inner
    sql_on: ${user_orders_fact_ndt.user_id} = ${users.id} ;;
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

explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

  join: user_orders_fact {
    type: left_outer
    sql_on: ${user_orders_fact.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_orders_fact_ndt {
    type: left_outer
    sql_on: ${user_orders_fact_ndt.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
