# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: ndt_brands_rankings {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_sales desc) ;;
      }
      bind_all_filters: yes
    }
  }
  dimension: brand {
    primary_key: yes
  }

  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: brand_rank {
    hidden: no
    type:  number
  }

  dimension: is_brand_top5 {
    type: yesno
    sql: ${brand_rank} <=5 ;;
  }

  dimension: brand_top_5 {
    type: string
    sql: case when ${is_brand_top5} then  ${brand_rank}||') '||${brand}
         else 'Others'
         end
    ;;
  }

}
