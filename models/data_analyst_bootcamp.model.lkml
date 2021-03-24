connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  sql_trigger: SELECT GETDATE();;
  max_cache_age: "24 hour"
}

datagroup: data_analyst_bootcamp_order_items {
  sql_trigger: SELECT max(created_at) from public.order_items ;;
  max_cache_age: "4 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: data_analyst_bootcamp_order_items
  sql_always_where: ${order_items.returned_date} IS NULL ;;
  sql_always_having: ${order_items.total_sales} > 200 ;;
  #always_filter: {filters:[created_date: "before today"]}
  conditionally_filter: {
    filters:[created_date: "last 2 years"]
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

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}


# explore: products {}
explore: users {
  persist_with: data_analyst_bootcamp_default_datagroup
  label: "Darezik Users"
  join: order_items {
    from: users
    type: left_outer
    sql_on: ${users.id} = $(order_items.user_id)  ;;
    relationship: one_to_many
  }
}
