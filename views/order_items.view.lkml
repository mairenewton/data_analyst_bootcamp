view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    #hidden: yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    label: "Order Status"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_item_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

#-----------------------------------
#----------solutions----------------
#-----------------------------------

#   measure: distinct_count_orders {
#     label: "A count of unique orders"
#     type: count_distinct
#     sql: ${order_id} ;;
#   }

#   measure: total_sale {
#     label: "Total sale"
#     type: sum
#     value_format_name: eur
#     sql: ${sale_price} ;;
#   }

#   measure: avg_sale_price {
#     label: "Average of sale price"
#     type: average
#     value_format_name: eur
#     sql: ${sale_price} ;;
#   }

# #----------Ex3---------------
#   measure: total_sales_email_users {
#     description: "Total sales for users through email traffic source"
#     type: sum
#     value_format_name: eur
#     sql: ${sale_price} ;;
#     filters:  [
#       users.traffic_source: "Email"
#     ]
#   }

#   measure: percentage_sales_email_source {
#     type: number
#     value_format_name: percent_2
#     sql: 1.0*${total_sales_email_users}
#       /NULLIF(${total_sale}, 0) ;;
#   }


#   measure: average_spend_per_user {
#     type: number
#     value_format_name: eur
#     sql: 1.0*${total_sale}
#       /NULLIF(${users.count}, 0) ;;
#   }



}
