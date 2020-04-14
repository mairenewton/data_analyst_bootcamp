view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id { field: order_items.order_id }
      column: count_order_facts { field: order_items.count }
      column: total_sales { field: order_items.total_sales }
#       derived_column: order_rank {
#         sql:  ;;
#       }
    }
  }

  dimension: order_id {
    primary_key: yes
    type: number
  }

  dimension: count_order_facts {
    type: number
  }

  dimension: total_sales {
    value_format: "$#.##"
    type: number
  }

  measure: average_item_count_per_order {
    type: average
    sql: ${count_order_facts} ;;
  }

  measure: average_order_value {
    type: average
    sql: ${total_sales} ;;
  }

}
