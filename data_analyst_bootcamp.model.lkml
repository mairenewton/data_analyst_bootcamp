connection: "events_ecommerce"

# include all the views
include: "*.view"


# as a developer, you need to understand how your data flows in your data process so you know the best cache age
# you can also split this between different explores
# some may update it every 5-10 mins (transaction, new data every minute), or another one where its monthly (monthly snapshot type of data flow)
datagroup: data_analyst_bootcamp_default_datagroup { # caching policies and how you can override them
# by default 1 hour cache. if a user runs looks and queries the DB and within 1 hour another analyst sends the same query, it won't run it again, it'll retrieve the value in the cache
# sql_trigger: SELECT MAX(id) FROM etl_log;;
max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}  # these pop up in the menu

# This explore contains multiple views
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


explore: products {}


explore: users {
  description: "Data Analyst Bootcamp Explores"
  join: order_items{
    type: left_outer
    sql_on: ${users.id} == ${order_items.user_id} ;;
    relationship: one_to_many
  }

}

# making another explore based on a users.view
explore: usa_users {
  from:  users
  # view_name: users

  }
