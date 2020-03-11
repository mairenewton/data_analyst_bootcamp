# If necessary, uncomment the line below to include explore_source.
 include: "data_analyst_bootcamp.model.lkml"

view: order_facts_v2 {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_sales {}
      column: count {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_sales desc) ;;
      }
    }
  }
  dimension: id {
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count {
    type: number
  }

  dimension: order_revenue_rank {
    type: number

  }
}
