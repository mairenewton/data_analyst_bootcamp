
include: "/views/order_items.view"
include: "/views/users.view"
include: "/views/inventory_items.view"
include: "/views/products.view"
include: "/views/distribution_centers.view"


# This explore contains multiple views
explore: order_items {
  #view_name: order_items
  description: "Use this explore to analyse information related to order items"
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
