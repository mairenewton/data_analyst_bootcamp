# If necessary, uncomment the line below to include explore_source.

# include: "data_analyst_bootcamp.model.lkml"

view: native_table1 {
  derived_table: {
    explore_source: users {
      column: order_id { field: order_items.order_id }
      column: count { field: order_items.count }
      column: total_sales { field: order_items.total_sales }
    }
    distribution_style: all
    datagroup_trigger: order_items_datagroup
    indexes: ["order_id"]
  }
  dimension: order_id {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    #value_format: "€"#,##0.00"
    type: number
  }
  measure: avg_nb_items {
    type: average
    sql: ${TABLE}.count ;;
  }
  measure: Avg_order_value {
    type: average
    sql: ${TABLE}.total_sales ;;
  }
}
