view: top_5_brands_by_revenue {
    derived_table: {
      explore_source: order_items {
        bind_all_filters: yes
        column: brand { field: products.brand }
        column: sum { field: order_facts.sum }
        derived_column: brand_rank {
          sql: row_number() over (order by sum desc) ;; }
      # filters: [order_items.created_date: "365 days"]
      }
    }


    dimension: brand {primary_key: yes}

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
