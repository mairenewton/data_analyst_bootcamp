include: "/views/order_items.view.lkml"

view: customer_order_summary_native {
  derived_table: {
    explore_source: orders {
      column: customer_id {
        field: orders.customer_id
      }
      column: first_order {
        field: orders.first_order
      }
      column: total_amount {
        field: orders.total_amount
      }
    # filters: [order_items.created_date: "90 days"]
    }
  # persist_for: "8 hours"
  # indexes: ["customer_id"]
  datagroup_trigger: data_analyst_bootcamp_default_datagroup
  }
  dimension: customer_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.customer_id ;;
  }
  dimension_group: first_order {
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.first_order ;;
  }
  dimension: total_amount {
    type: number
    value_format: "0.00"
    sql: ${TABLE}.total_amount ;;
  }
}
