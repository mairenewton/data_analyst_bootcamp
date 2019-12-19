view: order_fact {
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: count {}
        column: total_sales {}
        derived_column: order_revenue_rank {
          sql: rank() over (partition by order_id order by total_sales desc) ;;
        }
        derived_column: avergae_revenue_per_item {
          sql: total_sales/nullif(count,0) ;;
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
      value_format: "$#,##0.00"
      type: number
    }
    dimension:  order_revenue_rank {
      type: number
    }
    dimension:  avergae_revenue_per_item {
      type: number
    }
  }
