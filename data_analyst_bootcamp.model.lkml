connection: "events_ecommerce"

# include all the views
include: "*.view"
# this is a new comment

datagroup: data_analyst_bootcamp_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items_update {
  sql_trigger: SELECT COUNT(*) FROM public.order_items ;;
}

persist_with: data_analyst_bootcamp_default_datagroup

explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_update

#  sql_always_where: ${created_date} > '2019-01-01' ;;
#   sql_always_having: ${total_sale_price} > 50 ;;
#
# access_filter: {
#   field: users.country
#   user_attribute: country
# }

  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: dt_user_order_facts {
    view_label: "Customers Order Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${dt_user_order_facts.order_items_user_id} ;;
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


explore: products {
  persist_with: order_items_update
}

explore: dt_user_order_facts {
  label: "User Order Facts"
  hidden: yes
}

explore: users {}
