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

datagroup: default {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_items {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

explore: inventory_items {
  join: products {
    type:  left_outer
    sql_on:  ${inventory_items.product_id} = ${products.id} ;;
    relationship:  many_to_one
  }
}

explore: order_items {
  persist_with:  order_items

  sql_always_where: ${order_items.status} = ‘complete’ ;;
  sql_always_having: ${order_items.count} > 5000 ;;

  always_filter: {
    filters: {
      field:  order_items.created_date
      value: "last 30 days"
    }
  }

  conditionally_filter: {
    filters: {
      field: order_items.created_date
      value: "last 2 years"
    }
    unless: [users.id]
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
  persist_with:  default
  access_filter: {
    field: users.state
    user_attribute: state
  }

  always_filter: {
    filters: {
      field: order_items.created_date
      value: "before today"
    }

    filters: {
      field: order_items.created_date
      value: "last 30 days"
    }
  }

  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
    }
    unless: [users.id, users.state]
  }

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

 join: inventory_items {
    type: left_outer
    sql_on: ${users.id} = ${inventory_items.product_id} ;;
    relationship: many_to_one
  }
}
