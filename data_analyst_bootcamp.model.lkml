connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: datagroup_test {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hours"
}


datagroup: datagroup_test2 {
  sql_trigger: SELECT MAX(created_at) from order_items;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup




explore: inventory_items {}
#

explore: order_items {

  always_filter: {
    filters: {
      field: created_date
      value: "Last 30 days"
    }
  }



  sql_always_where: ${status}='Complete' ;;
  sql_always_having: ${order_items.count}>5000 ;;

  persist_with: datagroup_test2


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


explore: users_sql {}

explore: products {}


explore: users {

  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
    unless: [id, state]

  }

  join: users_sql {
    type: left_outer
    sql_on: ${users_sql.user_id}=${users.id}  ;;
    relationship: one_to_one
  }


  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

  persist_with: datagroup_test
}
