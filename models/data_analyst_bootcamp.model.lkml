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

datagroup: default_24h {
  sql_trigger: select current_date;;
  max_cache_age: "24 hours"
}

explore: users {
  access_filter: {
    field: users.state
    user_attribute: state
  }
  persist_with: default_24h
  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
# This explore contains multiple views
explore: order_items {
  # sql_always_where: ${order_items.returned_date} IS NULL;;
  # sql_always_having: ${order_items.total_sales} > 200;;

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
join: user_facts {
  type: left_outer
  sql_on: ${users.id} = ${user_facts.user_id} ;;
  relationship: one_to_one
}
join: order_user_ndt {
  type: left_outer
  sql_on: ${order_items.order_id} = ${order_user_ndt.order_id} ;;
  relationship: many_to_one
}
}


# explore: products {}


# explore: users {}
