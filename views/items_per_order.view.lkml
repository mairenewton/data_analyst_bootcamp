# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: items_per_order {
  derived_table: {
    explore_source: order_items {
      column: order_item_id {}
      column: count {}
      column: total_sales {}
    }
  }
  dimension: order_item_id {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    type: number
  }

  measure: avg_items {
    type: average
    sql: ${count} ;;
  }

  measure: avg_price {
    type: average
    sql: ${count} ;;
  }

}
