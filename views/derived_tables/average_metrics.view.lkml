# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: average_metrics{
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: dim_count {}
      column: country { field: users.country }
      column: total_sales {}
    }
  }
  dimension: order_id {
    type: string
  }

  dimension: dim_count {
    hidden: yes
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: country {}

  dimension: total_sales {
    hidden: yes
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_order_item_count {
    type: average
    sql: ${dim_count} ;;
  }

  measure: average_total_sales {
    type: average
    sql: ${total_sales} ;;
  }
}
