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
  always_filter: {
    filters: {
      field: returned_date
      value: "NULL"
    }
    filters: {
      field: total_sales
      value: ">200"
    }
    filters: {
      field:  created_date
      value: "last 30 days"
    }
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

  description: "date filter is required unless id or state is used as a filter"
  conditionally_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
    unless: [id, state]
  }

  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id};;
    relationship: one_to_many
  }
}

explore: user_summary {
  from: derived_table_user_summary
}

explore: order_summary {
  from: order_header
}
