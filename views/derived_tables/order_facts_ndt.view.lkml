explore: order_facts_ndt {}

view: order_facts_ndt {
  derived_table: {
    datagroup_trigger: daily_refresh_datagroup
    distribution: "order_id"
    sortkeys: ["order_id"]


    explore_source: order_items {
      column: total_revenue {}
      column: count {}
      column: order_id {}
      derived_column: order_revenue_rank {
        sql: rank() over (order by total_revenue desc) ;;
      }
    }
  }
  dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count {
    description: ""
    type: number
  }
  dimension: order_id {
    primary_key: yes
    description: ""
    type: number
  }

  dimension: order_revenue_rank {
    type: number
    description: "Rank by total revenue amount per order"
  }

  measure: avg_count_items {
    type: average
    sql: ${count} ;;

  }

  measure: avg_total_revenue {
    type: average
    sql: ${total_revenue} ;;
  }

}
