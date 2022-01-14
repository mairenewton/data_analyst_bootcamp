include: "/views/*.view.lkml"

explore: users {
  description: "this provide more info about the explore"
  group_label: "All my explores"
  label: "users information"
  view_label: "My Customers"
  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }
}
