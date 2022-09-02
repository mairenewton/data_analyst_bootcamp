include: "/views/order_items.view"
include: "/views/inventory_items.view"
include: "/views/products.view"
include: "/views/distribution_centers.view"
include: "/views/users.view"


explore: order_items {

  sql_always_where: ${order_items.status} != 'Returned' ;;
  sql_always_having: ${order_items.sum_sale_price} > 200 ;;

  from: order_items
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
