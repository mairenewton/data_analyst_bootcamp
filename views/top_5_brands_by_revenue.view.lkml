view: top_5_brands_by_revenue {
    derived_table: {
      explore_source: order_items {
        column: brand { field: products.brand }
        column: sum { field: order_facts.sum }
        derived_column: brand_rank {
          sql: row_number() over (order by total_revenue desc) ;; }
      }
    }

    dimension: brand {}

    measure: sum {
      type: sum
    }

    dimension: brand_rank {}

    dimension: is_brand_rank_top_5 {
      type: yesno
      sql: ${brand_rank} <= 5 ;;
    }

    dimension: ranked_brands {
      type: string
      sql: case when ${is_brand_rank_top_5} then
        ${brand_rank}||') '||${brand}
        else 'Other' end;;
    }

  }
