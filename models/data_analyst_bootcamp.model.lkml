connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

include: "/explores/order_items_explore.lkml"
include: "/explores/users_explore.lkml"

include: "/explores/refinement_demo.lkml"
include: "/explores/extend_explore.lkml"



persist_with: daily_refresh_datagroup


datagroup: daily_refresh_datagroup {
  max_cache_age: "24 hours"
  sql_trigger: SELECT CURRENT_DATE() ;;
}


datagroup: order_items_change_datagroup {
  max_cache_age: "4 hours"
  sql_trigger: SELECT MAX(created_date) FROM order_items ;;

}












  # query: order_status_by_date{
  #   dimensions: [order_items.created_date, order_items.status]
  #   measures: [order_items.total_revenue]
  #   filters: [order_items.created_date: "last 30 days"]
  # }

  # query: orders_by_date{
  #   dimensions: [order_items.created_date]
  #   measures: [order_items.total_revenue]
  #   filters: [order_items.created_date: "last 30 days"]
  # }




# datagroup: data_analyst_bootcamp_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   sql_trigger:  SELECT MAX(completed_at) from etl_jobs ;;
#   max_cache_age: "1 hour"
# }

#persist_with: data_analyst_bootcamp_default_datagroup
