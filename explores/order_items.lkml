include: "/views/order_items.view"
include: "/views/users.view"
include: "/views/inventory_items.view"
include: "/views/products.view"
include: "/views/distribution_centers.view"


# This explore contains multiple views
explore: order_items {

  persist_with: order_items_change_datagroup
  label: "Order & Items & Users"
  description: "this provide more info about the explore"

  join: users {
    view_label: "Users Facts"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id};;
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

###-------
  # sql_always_where: ${order_items.status} != 'Returned' ;;
  # sql_always_having: ${order_items.total_sales} > 200 ;;

  # sql_always_where: ${order_items.status} = 'Complete' ;;
  # sql_always_having: ${count_order_items}  > 5 ;;


  #sql_always_where: ${created_date} >='2019-01-01' ;;

  # #sql_always_having: ${count_order_items} >= '1000' ;;
  # always_filter: {
  #   filters: [status: "Complete", users.country: "-UK"]
  # }

  # conditionally_filter: {
  #   filters: [order_items.created_date: "1 month"]
  #   unless: [users.state, users.city]
  # }
