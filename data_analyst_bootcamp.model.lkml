connection: "events_ecommerce"

# include all the views
include: "*.view"

datagroup: midnight {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: users_etl {
  sql_trigger:  select count(*) from public.users ;;
}

persist_with: midnight



explore: users {
  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: one_to_many
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: user_order_fact {
  join: users {
    type: inner
    sql_on: ${user_order_fact.id} = ${users.id} ;;
    relationship:  many_to_one
  }

}
