view: orders {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
      derived_column: sales_rank {
        sql: rank() over (order by total_sales desc) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    label: "Order Items Total Revenue"
    value_format_name: decimal_2
    type: number
  }
  dimension: sales_rank {
    type: number
  }
}
