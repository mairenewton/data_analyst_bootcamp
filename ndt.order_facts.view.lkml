view: customer_order_facts {
  derived_table: {
    explore_source: orders {
      column: customer_id {
        field: order.customer_id
      }
      column: first_order {
        field: order.first_order
      }
      column: lifetime_amount {
        field: order.lifetime_amount
      }
    }
  }
  dimension: customer_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.customer_id ;;
  }
  dimension_group: first_order {
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.first_order_date ;;
  }
  dimension: lifetime_amount {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.lifetime_amount ;;
  }
}
