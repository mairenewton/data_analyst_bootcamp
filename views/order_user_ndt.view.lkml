view: order_user_ndt {

    derived_table: {
      explore_source: order_items {
        column: total_sales {}
        column: count {}
        column: order_id {}
        derived_column: order_revenue_rank {
          sql: rank() over (order by total_sales desc) ;;
        }
      }
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: count {
      type: number
    }
    dimension: order_id {
      type: number
    }
  }
