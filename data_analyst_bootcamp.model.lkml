connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
    # SQL_TRIGGER - for Sql server and max_cache_age - is for druid - this is for how long the cache can live
    # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: data_analyst_bootcamp_test_datagroup {
  # SQL_TRIGGER - for Sql server and max_cache_age - is for druid - this is for how long the cache can live
  #sql_trigger: SELECT MAX(current_date) FROM etl_log;;
  sql_trigger: SELECT MAX(current_date) FROM calendar;;
  # max_cache_age: "1 hour"
}
persist_with: data_analyst_bootcamp_test_datagroup


# persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {
  # this can be added specific for just one view
  # persist_with: data_analyst_bootcamp_default_datagroup
}
#

explore: order_items {
  conditionally_filter: {
    filters: {
      field:created_date
      value: "last 2 years"
    }
    unless: [user_id]
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
}

explore: products {}

explore: users {
  always_filter: {
    filters: {
    field:created_date
    value: "before today"
    }
  }
}
