
include: "/views/users.view"
include: "/views/order_items.view"
include: "/views/inventory_items.view"


explore: users {
  view_name: users
  label: "Users Analysis"
  #view_label: "Users_label"
  description: "To analyse users - for marketing team"
  join: order_items {
    #fields: [order_items.profit, order_items.status]
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
