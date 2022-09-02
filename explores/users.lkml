include: "/views/*.view"


explore: users {
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
    relationship: one_to_one
    sql_on: ${users.id} = ${user_facts.user_id} ;;
  }
}
