connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


### Whitespaces ####

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  label: "Orders"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "Inventory & Products"
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

explore: products {
  join: inventory_items {
    type: left_outer
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    relationship: one_to_many
  }
}
# product ID is unique, so this is a one to many join - right outer is not in the list because not all
#sql dialects use right outer. - explore is select from part/view - joins are intellegient and not used if not needed.

# explore: users {}
