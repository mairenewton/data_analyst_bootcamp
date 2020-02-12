connection: "events_ecommerce"

# include all the views
include: "*.view"


datagroup: shr_data_model_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: shr_data_model_default_datagroup

explore : inventory_items {}
