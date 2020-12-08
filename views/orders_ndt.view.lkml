view: orders_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: total_sales {}
      column: order_item_count {field: count}
      derived_column: order_sales_rank {
        sql: rank() over(order by total_sales desc) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: total_sales {
    type: number
  }
  dimension: count {
    type: number
  }

  dimension: order_sales_rank {
    type: number
  }
}
