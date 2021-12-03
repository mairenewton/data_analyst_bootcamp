include: "/views/order_items.view.lkml"

view: customer_order_summary_sql {
  derived_table: {
    sql:
      SELECT
        customer_id,
        MIN(DATE(time)) AS first_order,
        SUM(amount) AS total_amount
      FROM
        orders
      GROUP BY
        customer_id ;;
  # persist_for: "8 hours"
  # indexes: ["customer_id"]
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
