view: order_facts {
    derived_table: {
      explore_source: users {
        column: order_id { field: order_items.order_id }
        column: count { field: order_items.count }
        column: total_sales { field: order_items.total_sales }
        bind_all_filters: yes
        }
      }
    dimension: order_id {
      type: number
    }
    dimension: count {
      type: number
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    measure: average_items_per_order {
      type: average
      sql: $count ;;
    }
    measure: average_order_value {
      type: average
      sql: $total_sales ;;
    }
  }
