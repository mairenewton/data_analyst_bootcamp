view: exercise_8 {
    derived_table: {
      sql: SELECT
               product_sku AS product_sku
                  ,SUM(cost) AS total_cost
              ,SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold
              FROM public.inventory_items
              GROUP BY 1
               ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: product_sku {
      primary_key: yes
      type: string
      sql: ${TABLE}.product_sku ;;
    }

    dimension: total_cost {
      type: number
      sql: ${TABLE}.total_cost ;;
      value_format_name: usd

    }

    dimension: cost_of_goods_sold {
      type: number
      sql: ${TABLE}.cost_of_goods_sold ;;
      value_format_name: usd

    }

    measure: percent_inventory_sold {
      type: number
      sql: ${cost_of_goods_sold}/${total_cost} ;;
      value_format_name: percent_1
    }

    set: detail {
      fields: [product_sku, total_cost, cost_of_goods_sold]
    }

  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: exercise_8 {
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
