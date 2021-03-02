connection: "events_ecommerce"


# include all the views
include: "*.view"

datagroup: order_etl {
  sql_trigger: SELECT MAX(created_at) FROM public.order_items;;
  max_cache_age: "24 hours"
}

# persist_with: data_analyst_bootcamp_default_datagroup


explore: users {
  label: "Tests"
  join: order_items {
  type: left_outer
  relationship: one_to_many
  sql_on: ${users.id} = ${order_items.user_id} ;;

}


 # sql_always_where: ${returned_date}is null  AND  ${status}='Complete' ;;
 # sql_always_having: ${total_sales}>200 AND ${order_items.count}>5000 ;;
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


#join: test_dt {
#  type: left_outer
#  sql_on: ${order_items.user_id} = ${test_dt.order_items_user_id} ;;
#  relationship: many_to_one
#}

#  join: ndt {
#    type: left_outer
#    sql_on: ${order_items.order_id} = ${ndt.order_id} ;;
#    relationship: many_to_one
}
