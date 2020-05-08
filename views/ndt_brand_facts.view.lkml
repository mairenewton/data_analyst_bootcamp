# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: ndt_brand_facts {
  derived_table: {
    explore_source: order_items {
      column: total_sales_prices {}
      column: brand { field: products.brand }
      derived_column: brand_rank {
        sql: rank() over (order by total_sales_prices desc );;
        }

      filters: {
        field: order_items.created_date
        value: "before today"
      }
    }
  }
  dimension: total_sales_prices {
    description: "Total Sales Field "
    type: number
  }
  dimension: brand {primary_key:yes}
}
