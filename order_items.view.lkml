view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    label: "Order Item ID"
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
    # hidden: yes
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


  measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
  }

#   dimension: profit {
#     type: number
#     value_format_name: usd
#     sql: ${sale_price} - ${inventory_items.cost} ;;
#     #Sales Price minus Inventory Cost
#   }

#   measure: total_profit {
#     type: sum
#     sql: ${profit} ;;
#   }

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price};;
    filters: {
      field: users.is_new_user
      value: "Yes"
    }
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

  dimension: shipping_days {
    description: "Number of days between shipped date and delivered date"
    type: number
    sql: DATEDIFF(day,${shipped_date},${delivered_date}) ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: order_item_count {
    type: count
    drill_fields: [detail*]
  }

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
