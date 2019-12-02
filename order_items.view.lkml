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
      month_name,
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
    sql: ${TABLE}.sale_price/100 ;;
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
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: Shipping_days {
    type:  duration_day
    sql_start: ${shipped_date};;
    sql_end: ${delivered_date};;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_Sales {
    type:  sum
    sql:  ${sale_price} ;;
  }

measure: average_cost {
  type:  average_distinct
  value_format_name:  gbp
  sql:  ${sale_price} ;;
}

measure: count_orders {
  description: "Count of orders"
  type:  count_distinct
  drill_fields: [detail*]

}

measure:count_order_items {
  description: "Count of Order Items"
  type:  count
  drill_fields: [detail*,-id,-users.id,-inventory_items.id]
}

  dimension: is_returned {
    type: yesno
    sql: ${status}='Returned' ;;
    }


measure: count_returned_items {
  type:  count
  filters: {
    field:  is_returned
    value: "Yes"
  }
}

  measure: percent_returned_items {
    type: number
    sql: 1.0*${count_returned_items} / ${count_order_items};;
    value_format_name: percent_2
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
