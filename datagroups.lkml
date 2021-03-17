datagroup: data_analyst_bootcamp_default_datagroup {
  # # sql_trigger: SELECT MAX(id) FROM etl_log;;
  # max_cache_age: "1 hour"
  sql_trigger: select current_date() ;;
}
