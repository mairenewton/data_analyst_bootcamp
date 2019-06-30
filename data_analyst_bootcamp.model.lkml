connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  sql_trigger: SELECT CURRENT_DATE ;;
  max_cache_age: "24 hours"
}
persist_with: data_analyst_bootcamp_default_datagroup

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

explore: inventory_items {}

explore: order_items {
  persist_with: order_items

  conditionally_filter: {
    filters: {
      field: users.country
      value: "USA"
    }
    unless: [order_items.status]
  }

  sql_always_where: ${returned_raw} IS NULL ;;
  sql_always_having: ${order_items.total_sales} > 200 ;;

# sql_always_where: upper(${order_items.status}) = upper('Complete') ;;
# sql_always_having: ${order_items.count} > 5000 ;;

#   always_filter: {
#     filters: {
#       field: created_date
#       value: "before today"
#     }
#   }

#   conditionally_filter: {
#     filters: {
#       field: created_date
#       value: "after 2 years ago"
#     }
#     unless: [users.id]
#   }


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
  persist_with: data_analyst_bootcamp_default_datagroup
  fields: [ALL_FIELDS*, -users.gender]
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

explore: user_facts {}

explore: order_facts_NDT {}
