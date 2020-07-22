view: brand_facts {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {field: order_items.total_sales}
      derived_column: brand_rank {
        sql:RANK () OVER
        (ORDER BY total_revenue desc) ;;
        }
    }
  }
  dimension: brand {
primary_key: yes
  }
  dimension: brand_rank {
    type: number
  }
  dimension: brand_rank_plus_brand_name {
    type: string
    sql: ${brand_rank}|| ') ' || ${brand} ;;
  }
 # dimension: brand_rank_plus_brand_name { (find out how to do this > 6 is Other)
 #   type: string
#  sql: casewhen ;;
#  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
}
