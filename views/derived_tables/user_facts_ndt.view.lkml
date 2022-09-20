explore: user_facts_ndt {}

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_revenue {}
      column: count_order {}
      filters: [order_items.created_date: "90 days"]
      derived_column: avg_customer_order {
        sql: total_revenue/count_order ;;
      }
    }
  }
  dimension: user_id {
    description: "User ID"
    primary_key: yes
    type: number
  }
  dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count_order {
    description: ""
    type: number
  }

  dimension: avg_customer_order {
    type: number
  }

  measure: avg_total_revenue {
    type: average
    sql: ${total_revenue} ;;
  }

}
