connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
datagroup:refresh_midnight_name  {
  sql_trigger: SELECT current_date;;
  max_cache_age: "24 hour"
}
persist_with: data_analyst_bootcamp_default_datagroup


### Whitespaces ####

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: refresh_midnight_name
  sql_always_where:${order_items.returned_date} IS NULL;;
  sql_always_having:${order_items.total_sale_price_email_user}>200;;
  always_filter: {
    filters: {
      field:order_items.created_date
      value:"before now"
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


# explore: products {}


#explore: users {
