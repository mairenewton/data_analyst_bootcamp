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

explore: inventory_items {
  #label: "My Inventory Items"
  #view_label: "My Inventory Items"
  #join: order_items {
  #  type:  left_outer
  #  sql_on:  ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  #  relationship:  one_to_many
  #}
}

explore: order_items {
  label: "My Orders"
  view_label: "My Orders"

  #sql_always_where: ${order_items.returned_date} IS NULL;;
  #sql_always_having: ${order_items.total_sales} > 200 ;;

  sql_always_where: ${order_items.status} = 'complete' ;;
  sql_always_having:  ${order_items.count} > 5000 ;;

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

explore: users {
  label: "My Users"
  view_label: "My Users"
  join: order_items {
    type:  left_outer
    sql_on:  ${users.id} = ${order_items.user_id} ;;
    relationship:  one_to_many
  }
}
