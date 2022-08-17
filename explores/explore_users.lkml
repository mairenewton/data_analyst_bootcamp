
include: "/views/users.view"
include: "/views/order_items.view"


explore: users {
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
}
