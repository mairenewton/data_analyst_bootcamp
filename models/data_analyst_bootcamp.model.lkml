connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items { #FROM
  group_label: "## - Data Analyst Bootcamp"

  sql_always_where: ${status} <> 'Returned' ;;
  sql_always_having: ${total_sale_price} > 200 ;;

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one #STEP 2 - ENSURING THERE IS NO "FANOUT"
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  description: "All Users Information"

  group_label: "## - Data Analyst Bootcamp"

  fields: [ALL_FIELDS*, -order_items.profit]

  conditionally_filter: {
    filters: [ order_items.created_date: "last 2 year"]
    unless: [users.id]
  }


  join: order_items {
    # fields: [order_items.order_id, order_items.sale_price, order_items.total_sale_price]
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}

# explore: products {}
