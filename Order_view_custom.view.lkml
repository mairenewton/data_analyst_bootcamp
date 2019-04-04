# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_view_custom {
  derived_table: {
    explore_source: order_items {
      column: id {}
      column: count {}
      column: total_sales {}
      derived_column: avg_revenue_item {
        sql: total_sales/ count;;
      }
      derived_column: order_total_revenue_rank {
        sql: Rank() over (order by total_sales desc)  ;;
      }

    }
  }
  dimension: id {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    type: number

  }
  dimension: avg_revenue_item  {
    type:  number
  }
  dimension: order_total_revenue_rank {
    type:  number
  }

}
