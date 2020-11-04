view: top_n_product {
derived_table: {

  explore_source: order_items {

    # Get by product_id the retail_price sold
    column: product_id {}
    column: total_sales {}


    # Derived column does a second 'pass' over the returned result, in this case, to determine the rank
    derived_column: rank_order {
      sql: DENSE_RANK() OVER (ORDER BY total_sales DESC) ;;
    }

    # Sort in descending order by the measure is essential here
    sorts: [total_sales: desc]
  }
}
dimension: product_id {
  hidden: yes
  primary_key: yes
  type: number
}
dimension: total_sales {
  hidden: yes
  type: number
}

# The rank order below can then be used to filter measures if desired

dimension: rank_order {
  type: number
  description: "Rank - Product (ID) by items sold in the past 12 months"
}
}
