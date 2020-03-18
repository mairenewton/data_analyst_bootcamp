# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: min_max_sales_by_product_id {
  derived_table: {
    explore_source: order_items {
      column: total_sales {}
      column: id { field: products.id }
    }
  }

  dimension: id {
    hidden: no
  }

  dimension: total_sales {
    hidden: no
  }

  measure: min_sales {
    type: min
    sql: ${total_sales} ;;
    hidden: yes
  }

  measure: max_sales {
    type: max
    sql: ${total_sales} ;;
    hidden: yes
  }

}

view: min_max_sales {
  derived_table: {
    explore_source: min_max_sales_by_product_id {
      column: max_sales {}
      column: min_sales {}
    }
  }

  dimension: min_sales {}
  dimension: max_sales {}

  dimension: relative_rank {
    type: number
    sql:  100.0*(${min_max_sales_by_product_id.total_sales}-${min_sales})
    /(${max_sales} - ${min_sales}) ;;

  }

  dimension: rank_tier {
    type: tier
    tiers: [10,20,30,40,50,60,70,80,90]
    sql: ${relative_rank} ;;
    style: integer
  }

}

explore: min_max_sales_by_product_id {

  join: min_max_sales {
    type: cross
    relationship: many_to_one
  }
}
