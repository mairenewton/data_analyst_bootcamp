explore: user_facts_ndt {
  description: "Showing only the last 90 days"
}

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_revenue {}
      column: count_order_items {}

      derived_column: revenue_by_order_count {
        sql: total_revenue/count_order_items  ;;
      }

      filters: [order_items.created_date: "90 days" ]

    }
  }
  dimension: id {
    type: number
    primary_key: yes
    hidden: yes
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: count_order_items {
    description: "Number of order items"
    type: number
  }


  dimension: revenue_by_order_count {
    type: number
  }

  measure: revenue_by_order_count_measure {
    type: number
    sql: ${total_revenue}/${count_order_items} ;;
  }

}
