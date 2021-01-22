view: order_facts_v3 {

    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: lifetime_orders { field: order_items.total_orders }
        column: lifetime_revenue { field: order_items.total_sales }
      }
    }
    dimension: user_id {
      type: number
    }
    dimension: lifetime_orders {
      type: number
    }
    dimension: lifetime_revenue {
      description: "Sum of sale price"
      value_format: "$#,##0.00"
      type: number
    }

  measure: total_lifetime_orders {
    description: "Use this for counting lifetime orders across many users"
    type: sum
    sql: ${lifetime_orders} ;;
  }

  measure: total_lifetime_order_count {
    type:  sum
    sql:  ${lifetime_orders} ;;
  }

  measure: total_lifetime_revenue {
    type: sum
    sql:  ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: avg_lifetime_revenue {
    type: average
    sql:  ${lifetime_revenue} ;;
    value_format_name: usd
  }
}


# view: order_facts_v3 {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
