include: "/views/users.view"
include: "/views/order_items.view"
include: "/views/inventory_items.view"
include: "/views/derived_tables/user_facts.view"


explore: users {

  persist_with: daily_refresh_datagroup

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

  join: user_facts {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}
