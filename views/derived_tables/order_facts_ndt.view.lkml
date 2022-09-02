explore: order_facts_ndt {}


view: order_facts_ndt {
  derived_table: {

    datagroup_trigger: order_items_change_datagroup

    # sql_trigger_value: SELECT CURRENT_DATE() ;;
    # persist_for: "24 hours"

  sortkeys: ["order_id"]
  distribution: "order_id"

    explore_source: order_items {
      column: order_id {}
      column: count_order_items {}
      column: total_revenue {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_revenue DESC) ;;
      }
    }
  }



  #---------------

  dimension: order_id {
    type: number
  }
  dimension: count_order_items {
    description: "Number of order items"
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: order_revenue_rank {
    type:  number
  }

  measure: avg_total_revenue {
    type: average
    sql: ${total_revenue} ;;
  }

  measure: avg_order_items_count {
    type: average
    sql: ${count_order_items} ;;
  }

}
