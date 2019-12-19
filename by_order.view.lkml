
view: by_order {
  derived_table: {
    explore_source: order_items {
      column: order_id {field: order_items.order_id}
      column: count {field: order_items.count}
      column: total_sales {field: order_items.total_sales}
      derived_column: avg_revenue {
        sql: 1.0*total_sales/nullif(count, 0) ;;
      }
      derived_column: revenue_rank {
        sql:rank() over(partition by order_id order by total_sales desc) ;;
      }
    }
  }

  dimension: order_id {
    primary_key: yes
    type: number
  }

  dimension: count {
    type: number
  }

  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: avg_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: revenue_rank {
    type: number
  }

  measure: sum_count {
    type: sum
    sql: ${count} ;;
  }

  measure: sum_total_sales {
    value_format: "$#,##0.00"
    type: sum
    sql: ${total_sales} ;;
  }

  measure: avg_revenue_group {
    value_format: "$#,##0.00"
    type: number
    sql:1.0*${sum_total_sales}/nullif(${sum_count},0)  ;;
  }
}
