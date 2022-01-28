view: order_facts {
  derived_table: {
    #datagroup_trigger: data_analyst_bootcamp_default_datagroup
    #partition_keys: []
    explore_source: order_items {
      column: order_id { field:order_items.order_id }
      column: total_sales {}
      column: count_of_orders {}
      derived_column: order_value_rank {
        sql: ROW_NUMBER() OVER (ORDER BY total_sales DESC) ;;
      }
    }
  }
  dimension: order_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }
  dimension: count_of_orders {
    type: number
    sql: ${TABLE}.count_of_orders ;;
  }
  dimension: order_value_rank {
    type: number
    sql: ${TABLE}.order_value_rank ;;
  }
  measure: average_order_value {
    type: average
    sql: ${total_sales} ;;
  }
}


# view: order_facts {
#   view_label: "Order Items"
#   derived_table: {
#     sql: SELECT
#         order_items.order_id,
#         order_items.user_id,
#         COUNT(*) as order_item_acount,
#         SUM(sale_price) as order_total
#       FROM public.ORDER_ITEMS as order_items
#       GROUP BY 1,2;;
#   }

#   dimension: order_id {
#     hidden: yes
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.order_id ;;
#   }

#   dimension: user_id {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }

#   dimension: order_item_acount {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.order_item_acount ;;
#   }

#   dimension: order_total {
#     #hidden: yes
#     type: number
#     sql: ${TABLE}.order_total ;;
#     value_format_name: usd_0
#   }

#   measure: average_order_value {
#     type: average
#     sql: ${order_total} ;;
#     value_format_name: usd_0
#   }

# }
