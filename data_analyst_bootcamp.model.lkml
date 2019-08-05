connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: data_analyst_bootcamp_default_datagroup {
#   sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: order_items {
#   label: "Orders"
#   description: "Order details"
#   group_label: "Order items only"


  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one

  }

  join: inventory_items {
#     view_label: "Inventory"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }


#   sql_always_where: ${created_date} >= current_date-7 ;;

#   always_filter: {
#       filters: {field: created_date value: "last 7 days"}
#     }

#     conditionally_filter: {
#         filters: {field: created_date value: "last 7 days"}
#         unless: [status]
#     }



}


explore: products {}


explore: users {}
