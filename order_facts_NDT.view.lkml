view: order_facts_NDT {
  derived_table: {
    datagroup_trigger: order_items
    distribution_style: even
    sortkeys: ["order_id"]
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
      derived_column: average_sales_per_order {
        sql: total_sales/count ;;
      }
      derived_column: order_rank {
        sql: rank() over(order by total_sales desc) ;;
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

  dimension: average_sales_per_order {
    type: number
    value_format_name: usd
  }

  dimension: order_rank {
    type: number
  }
}
