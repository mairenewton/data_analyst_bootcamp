# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: total_revenue {}
      column: count {}
      column: order_count {}
      derived_column: order_revenue_rank {
        sql: rank() over (order by total_revenue desc) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0"
    type: number
  }
  dimension: count {
    type: number
  }
}
