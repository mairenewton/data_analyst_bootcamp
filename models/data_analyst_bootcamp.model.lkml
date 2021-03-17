connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

include: "/datagroups"

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items_explore {
  view_name: order_items

  join: users {
    type: inner
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id}
    ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }


  join: users_summary {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users_summary.user_id} ;;
    relationship: many_to_one
  }


}


# explore: products {}


explore: users {}
include: "/views/users_summary.view"
# explore: users_summary {}
