

connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}



persist_with: data_analyst_bootcamp_default_datagroup




explore: inventory_items {}






explore: products {}


explore: order_items
{
  join: users {
    type:left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id}=${users;;
  }
}

explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id};;
    relationship: one_to_many
  }
}
