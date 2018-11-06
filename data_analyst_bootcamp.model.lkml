connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}



persist_with: data_analyst_bootcamp_default_datagroup




explore: inventory_items {}
#

explore: order_items {
  #sql_always_where: ${order_items.returned_date} IS NULL ;;
  #sql_always_having: ${order_items.total_sales} > 200 ;;
  sql_always_where: ${order_items.status} = 'complete' ;;
  sql_always_having: ${order_items.count} > 500 ;;
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

  join: derived_table_exercise {
    type: inner
    sql_on: ${order_items.user_id} = ${derived_table_exercise.user_id} ;;
    relationship: many_to_one
  }

  join: more_native_things {
    type: inner
    sql_on: ${order_items.id} = ${more_native_things.id} ;;
    relationship: one_to_one

  }

}




explore: products {}

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

explore: users {
  persist_with: default
  always_filter: {
    filters: {
      field: order_items.created_date
      value: "before today"
    }
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
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
  join: derived_table_exercise {
    type: inner
    sql_on: ${derived_table_exercise.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}
