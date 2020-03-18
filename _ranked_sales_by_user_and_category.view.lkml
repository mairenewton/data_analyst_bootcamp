# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: ranked_sales_by_user_and_category {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_sales {}
      column: product_category { field: inventory_items.product_category }

      ## Add this "derived column" to create the rank
      derived_column: rank { sql: RANK() OVER (PARTITION BY id ORDER BY total_sales DESC) ;;}
    }
  }

  dimension: id {
    type: number
  }

  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: product_category {}

  dimension: rank {
    type: number
  }

  measure: grand_total_sales {
    type: sum
    sql: ${total_sales} ;;
  }

  measure: top_1_total_sales {
    type: sum
    sql: ${total_sales} ;;
    filters: {
      field: rank
      value: "1"
    }
  }

  measure: pct_from_top_n {
    type: number
    value_format_name: percent_1
    sql: ${top_1_total_sales}/${grand_total_sales}  ;;
  }

  measure: categories {
    type: string
    ## You'll use STRINGAGG on SQL Server
    sql: LISTAGG(${product_category},' ,') ;;
  }


}

explore: ranked_sales_by_user_and_category {}
