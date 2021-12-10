# If necessary, uncomment the line below to include explore_source.

include: "/models/data_analyst_bootcamp.model.lkml"

view: brand_total_revenue_ndt {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sales {}
      derived_column: rank
      {
        sql: row_number () over (order by total_sales desc) ;;
      }
    }
  }
  dimension: brand {
    primary_key: yes
    label: "Product Information Brand"
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    label: "Orders Total Sales"
    type: number
  }
  dimension: rank {
    type: number
  }

  dimension: top_5_brand {
    type: yesno
    sql:  ${rank} <= 5  ;;
  }

  dimension: grouped_brands {
    type: string
    sql:  CASE WHEN ${top_5_brand} then ${rank} || ') '||${brand}
    else   '6) '|| "other " END;;
  }

}
