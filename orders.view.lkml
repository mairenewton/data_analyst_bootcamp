# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: orders {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
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
    value_format: "#,##0"
    type: number
  }
  dimension: order_revenue_rank {
    type: number
    sql: rank() over (order by ${total_sales})  ;;
  }
}
