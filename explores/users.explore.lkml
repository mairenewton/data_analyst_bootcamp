include: "/views/*.view"

explore: users {
  group_label: "Custom Group Name"
  description: "This is helpful for finding Users information"
  label: "Users Explore"
  join: order_items {
    fields: [order_items.total_revenue]
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
}
