connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  #group_label: "Developer Bootcamp"
  #label: "Training Order Items"
  #view_label: "Something Else"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    #fields: [users.show_in_order_items*]
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    #fields: [inventory_items.cost]
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

  join: orders {
    type:  inner
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: user_facts {
    type: inner
    sql_on:  ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }

  join: brand_order_facts_ndt {
    type: inner
    sql_on: ${products.brand}=${brand_order_facts_ndt.brand} ;;
    relationship: one_to_one
  }
}

#explore: orders {}

# explore: products {}
