# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: top_brands {
  derived_table: {
    explore_source: order_items {
      column: product_brand { field: inventory_items.product_brand }
      column: salesum {}
      derived_column: rank {
      sql: RANK() OVER (ORDER BY salesum)  ;;}
    }
  }
  dimension: product_brand {}
  dimension: salesum {
    type: number
  }
  dimension: rank {}
  dimension:  is_in_top_5 {
    type:  yesno
    sql: ${rank} <=5 ;;
  }
  dimension: rank_displ {
    type: string
    sql: case when ${is_in_top_5} = yes then ${product_brand} else 'other' end ;;
  }
}
