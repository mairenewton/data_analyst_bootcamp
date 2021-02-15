# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: product_fact_ndt {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: order_count {}

      filters: {
        field: order_items.created_date
        value: "30 days"
      }
    }
  }

  dimension: brand {
    primary_key: yes
    hidden: yes
  }

  dimension: order_count {
    hidden: yes
    description: "A count of unique orders"
    type: number
  }

  measure: order_count_sum {
    type: sum
    sql: ${order_count} ;;
  }
}
