# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_item_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
      derived_column: order_revenue_rank {
        sql:  rank() over(partition by order_id order by total_sales desc) ;;
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

  dimension: avg_revenue_item {
    sql: 1.0 * ${total_sales} / NULLIF(${count}, 0) ;;
  }

  dimension: order_revenue_rank {
    type: number
  }

}
