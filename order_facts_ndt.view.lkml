# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
      derived_column: avg_sales_per_order_item {
#         sql: ${total_sales}/nullif(${order_items.count}, 0) ;;
      }
      derived_column: order_revenue_rank {
        sql:  rank() over (partition by order_id order by total_sales desc) ;;
      }
    }
  }
  dimension: order_id {
    hidden: yes
    primary_key:  yes
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: avg_sales_per_order_item {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_revenue_rank{
   type:  number
  }
}
