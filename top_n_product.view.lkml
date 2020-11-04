view: top_n_product {
derived_table: {

  explore_source: products {

    # Get by product_id the total_items sold
    column: id {}
    column: retail_price {}


    # Derived column does a second 'pass' over the returned result, in this case, to determine the rank
    derived_column: rank_order {
      sql: DENSE_RANK() OVER (ORDER BY retail_price DESC) ;;
    }

    # Sort in descending order by the measure is essential here
    sorts: [retail_price: desc]
  }
}
dimension: id {
  hidden: yes
  primary_key: yes
  type: number
}
dimension: retail_price {
  hidden: yes
  type: number
}

# The rank order below can then be used to filter measures if desired

dimension: rank_order {
  type: number
  description: "Rank - Product (ID) by items sold in the past 12 months"
}
}
