view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: profit_1 {
    type: number
    sql: ${sale_price} - ${inventory_items.cost};;
  }

  parameter: top_x {
    type: number
  }

  dimension: top {
    type: number
    sql: {% parameter top_x %} ;;
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

  parameter: measure_selector {
    type: unquoted
    allowed_value: {
      label: "Total Sale Price"
      value: "1"
    }
    allowed_value: {
      label: "Total Profit"
      value: "2"
    }
    default_value: "1"

  }

  measure:  dynamic_measure{
    type: sum
    sql:
    {% if measure_selector._parameter_value == '1' %}
    ${sale_price}
    {% elsif measure_selector._parameter_value == '2' %}
    ${profit_1}
    {% else %}
    ${sale_price}
    {% endif %};;
    value_format_name: usd
    label_from_parameter: measure_selector
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

  measure: count_orders {
    type: count_distinct
    sql: $order_id ;;
  }

  measure: count_delivered_order_items {
    type: count
    drill_fields: [detail*]
    filters: {
      field: delivered_date
      value: "-Null"
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
