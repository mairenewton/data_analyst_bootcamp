# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: brand_order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: total_sales {}
      column: brand { field: products.brand }
      derived_column: brand_rank {sql: row_number() OVER (ORDER BY total_sales DESC) ;;}
    }
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: brand {
    primary_key: yes
  }

  dimension: brand_rank {
    type: number
    sql: ${TABLE}.brand_rank ;;
  }

  dimension: brand_rank_top_5 {
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }

  dimension: ranked_brands {
    type: string
    sql: CASE WHEN ${brand_rank_top_5} THEN ${brand} ELSE 'Other' END  ;;
  }
}
