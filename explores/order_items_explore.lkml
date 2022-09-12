
include: "/views/order_items.view"
include: "/views/users.view"
include: "/views/inventory_items.view"
include: "/views/products.view"
include: "/views/distribution_centers.view"


# This explore contains multiple views
explore: order_items {
   view_name: order_items

  #persist_with: order_items_change_datagroup


  # sql_always_where: ${order_items.status} != 'Returned' ;;
  # sql_always_having: ${order_items.total_revenue} > 200 ;;


  description: "this provide more info about the explore"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one

  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
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
}





 # sql_always_where: ${created_date} >= '2019-01-01' ;;
  # # always_filter: {
  # #   filters: [users.country: "USA"]}

  # conditionally_filter: {
  #   filters: [order_items.created_date: "1 month"]
  #   unless: [users.state, users.age_group]
  # }
