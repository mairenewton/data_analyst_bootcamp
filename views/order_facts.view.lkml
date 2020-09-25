# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_facts {
  derived_table: {
    explore_source: users {
      column: order_id { field: order_items.order_id }
      column: count_of_orders { field: order_items.count_of_orders }
      column: total_sales { field: order_items.total_sales }
      derived_column: rank {
        sql: RANK() OVER(ORDER BY total_sales desc) ;;
      }
    }
    # datagroup_trigger: order_items
    sql_trigger_value: SELECT MAX(created_at);;
  }

  dimension: order_id {
    primary_key: yes
    type: number
  }

  dimension: count_of_orders {
    type: number
  }

  dimension: rank {
    type:  number
  }

  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_orders_count {
    type: average
    sql: ${count_of_orders} ;;
  }

  measure: average_orders_value {
    type: average
    sql: ${total_sales} ;;
    value_format_name: usd
  }
}
