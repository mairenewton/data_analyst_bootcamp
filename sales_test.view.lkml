# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: add_a_unique_name_1615324068 {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
    }
  }
  dimension: brand {}
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_total_sales {
    type: average
    sql: total_sales ;;
  }
  }
