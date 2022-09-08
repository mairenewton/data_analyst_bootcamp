#example of extending explores
#use case: if you have a team needing to see different fields, but you do not want to repeat the code in creating the same explore with multiple joins

include: "/explores/order_items_explore.lkml"


explore: order_items_extended {
  extends: [order_items]
  fields: [
          order_items.count_users,
          order_items.count_orders,
          order_items.count_items_ordered,
          order_items.returned_year,
          products.category
            ]
}
