view: order_items {
  sql_table_name: public.order_items ;;
#test comment
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
#   sql: public.order_items.id ;;
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

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
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


  measure: total_sale_price {
    group_label: "Sum Measures"
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    }

  measure: total_sale_price_new_users {
    group_label: "Sum Measures"
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: users.is_new_user
      value: "yes"
    }
    drill_fields: [detail*]
    }

  measure: average_sale_price {
    group_label: "Average Measures"
    type: average
    sql: ${sale_price} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
    }

  measure: average_profit {
    group_label: "Average Measures"
    type: average
    sql: ${profit} ;;
    drill_fields: [detail*]
    }

  measure: count {
    group_label: "Count Measures"
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct_users {
    group_label: "Count Measures"
    type: count_distinct
    sql: ${user_id} ;;
    drill_fields: [detail*]
    }

  measure: count_new_user_orders {
    group_label: "Count Measures"
    type: count
    filters: {
      field: users.is_new_user
      value: "yes"
    }
    drill_fields: [detail*]
    }

  measure: percentage_of_new_users {
    type: number
    sql: 1.0 * ${count_new_user_orders} / NULLIF(${count},0) ;;
    value_format_name: percent_1
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name,
      total_sale_price_new_users,
      total_sale_price,
      average_profit
    ]
  }
}
