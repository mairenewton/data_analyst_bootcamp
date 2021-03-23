view: brand_order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: product_brand { field: inventory_items.product_brand }
      column: total_sale_price {field:order_items.total_sale_price}
      bind_all_filters: yes
      # bind_filters: {
      #   from_field:
      #   to_field:

      # }
      derived_column: rank {
        sql: row_number() over(order by total_sale_price desc);; }



    }


  }
  dimension: product_brand {
    primary_key: yes
  }
  dimension: total_sale_price {
    description: "Sum of sale price"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: rank {
    type: number
  }
}
