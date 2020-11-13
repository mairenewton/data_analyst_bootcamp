# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: brand_order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
      derived_column: brand_rank {
        sql: ROW_NUMBER () OVER (ORDER BY total_sales DESC ) ;;
      }
      filters: [order_items.created_date: "10 days"]
      #bind_filters: {
      #  from_field: order_items.created_date
      #  to_field: order_items.created_date
      #}
      #bind_all_filters: yes
    }
  }
  dimension: brand {
    primary_key: yes
    type: string
  }

  dimension: total_sales {
    type: number
    #value_format: "$#,##0.00"
    value_format_name: usd
  }

  dimension: brand_rank {
    type: number
  }

  dimension: is_top_5 {
    type: yesno
    sql: CASE WHEN ${brand_rank} <= 5 THEN TRUE ELSE FALSE END ;;
  }

  dimension: brand_label {
    type: string
    sql: CASE WHEN ${is_top_5} THEN ${brand_rank}::VARCHAR || ') ' || ${brand} ELSE 'Other' END ;;
  }

  measure: sum_total_sales {
    type: sum
    sql: ${total_sales} ;;
    value_format_name: usd
  }

}
