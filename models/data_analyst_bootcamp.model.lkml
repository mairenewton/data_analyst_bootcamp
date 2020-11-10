connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/*"


datagroup: data_analyst_bootcamp_default_datagroup {
 sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items_datagroup {
  sql_trigger: select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_datagroup
 #   sql_always_where: ${order_items.returned_date} IS NULL;;
#   sql_always_having: ${order_items.total_sales} > 200;;
# conditionally_filter: {
#   filters: [order_items.created_date: "last 2 years"]
#   unless: [users.id]
# }

#  view_label: "Orders"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
#    view_label: "Inventory"
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

explore: users  {
  # always_filter: {
  #   filters: [order_items.created_date: "before today"]
 # }
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: user_facts {
  type: inner
  sql_on: ${order_items.user_id} = ${user_facts.user_id};;
  relationship: one_to_one
  }
}

explore: order_facts2 {}

explore: monthly_profitability_summary {}


# explore: products {
#   persist_with: order_items_datagroup
# }


#explore: users {}
