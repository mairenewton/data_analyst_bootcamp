connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}



persist_with: data_analyst_bootcamp_default_datagroup


explore: inventory_items {}


explore: order_items {
  always_filter: {
    filters: {
      field: created_date
      value: "before today"
    }
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

}




explore: products {}


explore: users {
  join: user_order_facts {
    type: inner
    sql_on: ${users.id}=${user_order_facts.id} ;;
    relationship: one_to_one
  }


}
