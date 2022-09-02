connection: "events_ecommerce"

# include all the explores
include: "/explores/order_items.lkml"
include: "/explores/users.lkml"
include: "/views/derived_tables/user_facts_ndt.view"
include: "/views/derived_tables/order_facts_ndt.view"


#include: "/views/derived_tables/user_facts_ndt.view"


datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger:  SELECT MAX(completed_at) from etl_jobs ;;
  max_cache_age: "1 hour"
}

persist_with: data_analyst_bootcamp_default_datagroup


datagroup: daily_refresh_datagroup {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}



datagroup: order_items_change_datagroup {
  sql_trigger: SELECT MAX(created_at) FROM order_items ;;
  max_cache_age: "4 hours"



}
