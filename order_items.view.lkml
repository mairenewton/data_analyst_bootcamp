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

dimension: days_since_order_to_delivery {
  label: " days since delivery"
  description: " do u know hwat this mean?"
  type:  number
#  sql:    ${delivered_date} - ${shipped_date} ;;
  sql:  datediff('day', ${shipped_date},${delivered_date});;
}

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
hidden: yes
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
    hidden:  yes
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
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
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

  measure: distinct_nbr_of_orders {
    type: count_distinct
    sql: ${order_id} ;;

  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: "usd_0"
  }

  measure: average_sales {
    type:  average
    sql:  ${sale_price} ;;
    value_format_name: "usd"
  }

measure: total_sales_new_users {
  type: sum
  sql:  ${sale_price} ;;
  value_format_name: usd_0
  filters: {
    field: users.is_new_user
    value: "Yes"
  }
}

measure: total_sales_from_email {
  type:  sum
  sql:  ${sale_price} ;;
  value_format_name: usd_0
  filters: {
    field:  users.is_traffic_source_email_yesno
    value: "Yes"
    }
}

  measure: total_sales_from_email2 {
    type:  sum
    sql:  ${sale_price} ;;
    value_format_name: usd_0
    filters: {
      field:  users.traffic_source
      value: "Email"
    }
  }


measure: percentage_of_sales_from_email {
  type:  number
  sql: ${total_sales_from_email} / nullif (${total_sales},0) ;;
value_format_name: percent_1
}

  measure:  average_spend_per_user {
    type:  number
    sql:  ${total_sales} / ${users.count} ;;
    value_format_name: usd_0
  }

}
