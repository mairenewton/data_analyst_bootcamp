view: ndt_order_fcts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sales {}
    }
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }

  measure: avg_order_item_count {
    type: average
    sql: ${count} ;;
  }

  measure: avg_total_sale_price {
    type: average
    sql: ${total_sales} ;;
  }
}
