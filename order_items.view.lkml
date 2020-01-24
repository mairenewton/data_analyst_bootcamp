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
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: date {
    type: string
    label_from_parameter: select_date_granuality
    sql:
    {% if select_date_granuality._parameter_value == 'day' %}
      ${created_date}
    {% elsif select_date_granuality._parameter_value == 'month' %}
      ${created_month}
    {% else %}
      ${created_date}
    {% endif %};;
  }

#   dimension: dynamic_timeframe {
#     type:  string



 # }

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

  #Shipping days variant one
  dimension: shipping_days {

    type: number
    sql: datediff(day, ${shipped_raw}, ${delivered_raw}) ;;

  }

  dimension_group: shipping_days1  {

    type: duration
    intervals: [day]
    sql_end: ${shipped_raw};;
    sql_start: ${delivered_raw} ;;


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

  measure: distinct_orders {
    type:  count_distinct
    sql:  ${order_id} ;;
  }


  measure: average_sales {
    type:  average
    sql:  ${sale_price} ;;
    value_format_name: usd
  }


  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_email
  {
    type: sum
    sql:  ${sale_price} ;;
    value_format_name:  usd
    filters: {
      field: users.is_email
      value: "Yes"
    }

  }

  measure: sales_percentage_email {

    type: number
    value_format_name: percent_1
    sql:  1.0* ${total_sales_email} / nullif(${total_sales}, 0) ;;

  }

  measure: average_spend_per_user {
    type:  number

    sql: ${total_sales} / ${users.count} ;;

  }

  parameter: select_date_granuality {
    type:  unquoted
    allowed_value: {label: "day" value: "day"}
    allowed_value: {label: "week" value: "week"}
    allowed_value: {label: "month" value: "month"}
    default_value: "date"
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
