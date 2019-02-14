connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
 sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
datagroup: daily_data_group {
  sql_trigger: select current date;;
  max_cache_age: "24 hour"
}
persist_with: data_analyst_bootcamp_default_datagroup
#persist_for: "360 minutes"
explore: inventory_items {}
#

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
datagroup: order_items_always_maxdate{
  sql_trigger: SELECT MAX(created_at) from order_items ;;
}
explore: products {}


explore: users {
  join: sql_runner_query {
    sql_on: ${users.id}=${sql_runner_query.user_id} ;;
    relationship: one_to_many
  }
}
