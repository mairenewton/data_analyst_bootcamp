connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
# include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

datagroup: users {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup




explore: inventory_items {}
#

explore: order_items {
  label: "Order Items Detail"
  view_label: "order items raw"

  persist_with: order_items

  fields: [ALL_FIELDS*]

  always_filter: {
    filters: {
      field: order_items.if_returned
      value: "No"
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

  join: derived_table {
    type: left_outer
    sql_on: ${derived_table.user_id} = ${users.id} ;;
    relationship: one_to_one
  }

  join: order_facts {
    view_label: "order summary"
    type: left_outer
    sql_on: ${order_facts.order_id} = ${order_items.order_id};;
    relationship: one_to_one
  }

}




explore: products {}


explore: users {
  persist_with: users

  description: "users and order items info"
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
