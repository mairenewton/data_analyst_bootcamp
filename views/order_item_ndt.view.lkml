# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_item_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count_of_orders_items {}
      column: total_revenue {}
      derived_column:  order_rank {
        sql: rank() over(order by total_revenue/count_of_orders_items desc) ;;
      }
    }
#     sql_trigger_value: select current_date ;;
# persist_for: "4 hours"
# datagroup_trigger: orders_items_datagroup
  }

  dimension: order_id {
    type: number
  }
  dimension: count_of_orders_items {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0"
    type: number
  }
  dimension: order_rank {
    type: number
  }
}
