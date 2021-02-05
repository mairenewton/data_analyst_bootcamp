# If necessary, uncomment the line below to include explore_source.
include: "/models/data_analyst_bootcamp.model.lkml"

view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: count {}
      column: total_sale_price {}
      derived_column: order_value_ranked {
        sql: RANK() OVER(ORDER BY ${total_sale_price}) ;;
      }
    }
    sql_trigger_value: SELECT CURRENT_DATE ;;
  }
  dimension: order_id {
    primary_key: yes
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: total_sale_price {
    type: number
  }
  dimension: order_value_ranked {}
}
