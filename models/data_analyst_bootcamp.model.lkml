connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

datagroup: users_cache {
  max_cache_age: "24 hours"
  sql_trigger: SELECT max(id) FROM users ;;

}

explore: users {
  persist_with: users_cache
  join: order_items {
  type:  left_outer
    sql_on: ${users.id} =${order_items.user_id} ;;
    relationship: one_to_many
  }
}


explore: inventory_items {}

# This explore contains multiple views
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

  join: users_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users_facts.user_id}  ;;
    relationship: many_to_one

  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
#  join: brand_facts  {
 #   type: inner
  #  sql_on: ${products.brand}=${brand_facts.brand} ;;
   # relationship: many_to_one
  #}

  sql_always_where: ${returned_flag}='Yes' ;;
  sql_always_having: ${total_sales_prices}>200 ;;
}

 explore: events {}


explore: products {


}

# explore: users {}
