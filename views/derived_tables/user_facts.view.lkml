view: user_facts_columns {
  extension: required

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }
  dimension: count_of_orders {
    type: number
    sql: ${TABLE}.count_of_orders / 10;;
  }

  dimension: user_rank {
    type: number
    sql: ${TABLE}.user_rank ;;
  }

  measure: average_lifetime_order_value {
    type: average
    sql: ${total_sales} ;;
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${count_of_orders} ;;
  }

}

view: user_facts {
  extends: [user_facts_columns]
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_sales {}
      column: count_of_orders {}
      derived_column: user_rank {
        sql: RANK() OVER (ORDER BY count_of_orders)  ;;
        #comments here
      }
      # # filters: [
      # #   order_items.created_date: "1 month"
      # # ]
      # #bind_all_filters: yes
      # bind_filters: {
      #   from_field: order_items.status
      #   to_field: order_items.status
      # }
    }
  }

}

# view: user_facts {
#   view_label: "Users"
#   derived_table: {
#     sql: SELECT
#         order_items.user_id,
#         COUNT(DISTINCT order_id) as lifetime_orders,
#         SUM(sale_price) as lifetime_order_value
#       FROM public.ORDER_ITEMS as order_items
#       GROUP BY 1;;
#   }

#   dimension: user_id {
#     primary_key: yes
#     hidden: yes
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }

#   dimension: lifetime_orders {
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }

#   dimension: lifetime_order_value {
#     type: number
#     sql: ${TABLE}.lifetime_order_value ;;
#   }

#   measure: average_lifetime_orders {
#     type: average
#     sql: ${lifetime_orders} ;;
#   }

#   measure: average_lifetime_order_value {
#     type: average
#     sql: ${lifetime_order_value} ;;
#   }

# }
