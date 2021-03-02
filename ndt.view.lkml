# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {field: order_items.order_id}
      column: order_count {}
      column: total_sales {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_sales desc);;
      }
    }
  }

  measure: average_items_per_order {
    type: average
    sql: ${order_count} ;;
  }

  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number

}
}
