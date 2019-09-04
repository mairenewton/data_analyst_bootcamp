connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: select count(*) from order_items ;;

}

persist_with: data_analyst_bootcamp_default_datagroup

# This explore contains multiple views
explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one




  }

#
#   join: users_orders_facts_dt {
#     type: inner
#     sql_on: ${users_orders_facts_dt.usersid} = ${users.id} ;;
#     relationship: many_to_one
#   }


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

  join: user_sales_count_native_dt {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_sales_count_native_dt.user_id} ;;
    relationship: many_to_one


}
}

explore: products {}


explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id}=${order_items.order_id} ;;
    relationship: one_to_many
  }
  join: user_sales_count_native_dt {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_sales_count_native_dt.user_id} ;;
    relationship: many_to_one


  }

}

datagroup: order_item {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}
