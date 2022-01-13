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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
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

  # dimension: sale_prices {
  #   type: number
  #   sql: ${TABLE}.sale_price ;;
  # }


##################### Creating new dimensions  #####################




  # dimension: sale_price {
  #   type: number
  #   sql: ${TABLE}.sale_price ;;
  # }

 # measure: average_sale_price {
 #   type: average
 #   sql: ${sale_price} ;;
 # }

################################## MEASURES ######################

  measure: total_sale_price {
    type: sum
    sql: ${TABLE}.sale_price;;
  }

  measure: average_sale_price {
    type: average
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd_0
  }

 measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
  }



  # measure: avg_sale_price {
  #   type: average
  #   sql: ${sale_prices} ;;
  # }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure:  order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: order_counts_shipped {
    type: count_distinct
    sql: ${order_id} ;;
    filters: [status: "Shipped"]
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
}
