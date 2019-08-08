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


dimension:  days_to_deliver{
  type: duration_day
  sql_start: ${created_raw} ;;
  sql_end: ${delivered_raw} ;;
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

dimension: Profit_per_item {
  type: number
  sql: ${sale_price} - ${inventory_items.cost} ;;
  value_format_name: usd
}

parameter: measure_selector {
  type: unquoted
  allowed_value: {
    label: "Total Sales"
    value: "1"
  }
  allowed_value: {
    label: "Total Profit"
    value: "2"
  }
  default_value: "1"
}

measure: dynamic_measure {
  type: sum
  sql:
  {% if measure_selector._parameter_value == '1' %}
  ${sale_price}
  {% elsif measure_selector._parameter_value == '2' %}
  ${Profit_per_item}
  {% else %}
  ${sale_price}
  {% endif %} ;;
  value_format_name: usd
  label_from_parameter: measure_selector
}

  measure: total_revnue {
    type: sum
    sql: ${Profit_per_item} ;;
    value_format_name: usd
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_delivered_ordered_items {
    type: count
    drill_fields: [detail*]
    filters: {
      field: delivered_date
      value: "-NULL"
    }
  }

  measure: percentage_of_delivered {
    description: "Percentae of delivered items"
    type: number
    sql: 1.00 * ${count_delivered_ordered_items}/${count} ;;
    value_format_name: percent_2
  }

  measure: count_of_order {
    type: count_distinct
    sql: ${order_id} ;;

  }

  measure: total_sales_email_users{
   type: sum
  value_format_name: decimal_2
  sql: ${sale_price} ;;
  filters: {
    field: users.traffic_source
    value: "Email, Display"
  }
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
