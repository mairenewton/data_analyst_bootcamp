# If necessary, uncomment the line below to include explore_source.

include: "*.view.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales_price {}
      derived_column: order_revenue_rank{
        sql: rank() over(order by total_sales_price desc) ;;
      }
      bind_all_filters: yes
      #filters: {
      #  field: order_items.created_date
      #  value: "after 30 days ago"
      #}
    }
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales_price {
    description: "TotaL Sales"
    value_format: "#,##0.00"
    type: number
  }
}
