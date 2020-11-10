# If necessary, uncomment the line below to include explore_source.
include: "/models/data_analyst_bootcamp.model.lkml"

view: order_facts2 {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: total_sales {}
      column: order_count {}
      derived_column: order_revenue_rank {
        sql: rank() over (order by total_sales desc) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }

  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }

  dimension: order_revenue_rank {
    type: number
  }
}
