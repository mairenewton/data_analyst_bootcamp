# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"
#explore: brand_order_facts_ndt {}

view: brand_order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_sales desc) ;;
      }
      #filters: [order_items.created_date: "365 days"]

      # bind_filters: {
      #   from_field: order_items.created_date
      #   to_field: order_items.created_date
      # }
      bind_all_filters: yes
    }
  }
  dimension: brand {
    primary_key: yes
  }
  dimension: total_sales {
    type: number
  }

  dimension: brand_rank {
    type: number
  }

  dimension: is_brand_rank_top_5 {
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }

  dimension: ranked_brands {
    type: string
    sql: case when ${is_brand_rank_top_5} then ${brand_rank} || ') ' || ${brand}
    else 'Other' End;;
  }
}
