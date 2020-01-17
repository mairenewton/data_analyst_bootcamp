connection: "events_ecommerce"
include: "*.view"
# include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore:  users{
 join: order_items {
 relationship: many_to_one
sql_on: ${users.id} = ${order_items.user_id} ;;

}

#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
 }
