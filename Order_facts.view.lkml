view: order_facts {
     derived_table: {
      explore_source: order_items {
        column: order_id {field: order_items.order_id}
        column: count { field: order_items.count}
        column: total_sales {field: order_items.total_sales}
        derived_column:order_revenue_rank{
          sql: rank() over (partition by order_id order by total_sales desc);;
          }
        derived_column: average_revenue_per_item{
          sql:  total_sales/nullif(count,0) ;;
      }
    }
    }
    dimension: order_id {
      type: number
      primary_key:  yes
      hidden:  yes
    }
    dimension: count {
      type: number
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_revenue_rank {
      type:  number
    }
    dimension: average_revenue_per_item {
      type:  number
    }
    }

