view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_completed_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "Complete"
    }
    value_format_name: usd
  }

  measure: percent_completed_revenue {
    type: number
    sql: ${total_completed_revenue} / ${total_sale_price} ;;
    value_format_name: percent_2
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
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
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

dimension: shipping_days {
  type:  number
  sql:  datediff('day',${shipped_raw},${delivered_raw}) ;;
 }


  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure : order_count_distninct {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure : total_sales {
    type: sum
    sql: ${sale_price} ;;
  }
  measure : avg_sales {
    type: average
    sql: ${sale_price} ;;
  }

# measure: total_sales_email {
#   type: sum
#   sql:${sale_price} ;;
#   value_format_name: usd
#   filters: {
#       field: users.is_email
#       value: "Yes"
#   }
# }

# measure: percent_sales {
#   type: number
#   sql: 1.0 * ${total_sales_email}
#         /NULLIF(${total_sales},;;
# }
#


#   measure: avg_spend {
#     type: number
#     sql: 1.0 * ${total_sales}
#       /NULLIF(${users.count},0),;;
#   }
  # ----- Sets of fields for drilling ------

  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
