# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {field:order_items.order_id}
      column: count_items {field:order_items.count}
      column: total_sales {field:order_items.total_sales}
    }
  }
  dimension: order_id {
    type: number
    primary_key: yes

  }
  dimension: count_items {
    type: number

  }
  dimension: total_sales {
    value_format: "$#.##"
    type: number

  }

  measure: average_item_count_per_order {
    type: average
    sql: ${count_items} ;;
  }

  measure: average_order_value {
    type: average
    sql: ${total_sales} ;;
  }
}
