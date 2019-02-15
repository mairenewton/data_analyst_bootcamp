# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_header {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
      derived_column: avg_rev_per_item {
        sql: total_sales/count ;;

      }
      derived_column: order_rev_rank {
        sql: RANK () OVER (ORDER BY total_sales DESC) ;;
      }
      filters: {
        field: order_items.returned_date
        value: "NULL"
      }
      filters: {
        field: order_items.total_sales
        value: ">200"
      }
      filters: {
        field: order_items.created_date
        value: "30 days"
      }
    }
    persist_for: "24 hours"
    distribution_style: even
    sortkeys: ["order_id"]
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    type: number
  }
  dimension: avg_rev_per_item {
    type: number
  }
  dimension: order_rev_rank {
    type: number
  }

}
