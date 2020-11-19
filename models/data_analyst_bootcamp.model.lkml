connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: nightly_etl  {
  max_cache_age: "15 hours"
  sql_trigger: select current_date ;;
}

datagroup: default {
  max_cache_age: "24 hours"
  sql_trigger: select current_date ;;
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: nightly_etl
 #  sql_always_where: ${created_date} > '2017-01-01' AND ${status} = 'Delivered';;

  # always_filter: {
  #   filters: [order_items.status: "Delivered"]
  # }


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

  join: ndt_brands_rankings {
    type: inner
    sql_on: ${products.id} = ${ndt_brands_rankings.brand} ;;
    relationship: one_to_one

  }

  join: dt_order_facts {
    view_label: "Order Facts"
    type: left_outer
    sql_on: ${order_items.order_id} = ${dt_order_facts.order_id} ;;
    relationship: many_to_one
  }
}


# explore: products {}


explore: users {
  persist_with: default
}
