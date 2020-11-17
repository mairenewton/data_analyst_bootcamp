view: order_items {
  sql_table_name: public.order_items ;;


  parameter: select_timeframe {
    type: unquoted
    default_value: "created_month"
    allowed_value: {
      value: "created_date"
      label: "Date"
    }
    allowed_value: {
      value: "created_week"
      label: "Week"
    }
    allowed_value: {
      value: "created_month"
      label: "Month"
    }
  }


 dimension: dynamic_timeframe {
    label_from_parameter: select_timeframe
    type: string
    sql:
    {% if select_timeframe._parameter_value == 'created_date' %}
    ${created_date}
    {% elsif select_timeframe._parameter_value == 'created_week' %}
    ${created_week}
    {% else %}
    ${created_month}
    {% endif %} ;;
    }
##comment

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

  dimension_group: shipping_days {
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day, month, week]
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
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  measure: average_sales {
    description: "average sales"
    type: average
    sql: ${sale_price} ;;
  }

  measure: order_count {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: unique_orders {
    description: "Unique Orders based on Order ID"
    type: count_distinct
    sql: ${order_id} ;;

  }

  measure: average_sales_dip {
    label: "Avg Sales"
    group_label: "Sales Metrics"
    value_format_name: usd
    type: average
    sql: ${sale_price} ;;
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}/NULLIF(${total_sales},0) ;;
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: ${total_sales}/${users.count} ;;
  }

  measure: total_sales {
    group_label: "Sales Metrics"
    value_format_name: usd
    type: sum
    sql: ${sale_price} ;;
    drill_fields: [user_id, sale_price]
  }

  measure: total_sales_email_users {
    group_label: "Sales Metrics"
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_source: "Yes"]
    drill_fields: [detail*, users.is_email_source, -users.first_name,-users.first_name]
  }

  measure: count_without_liquid {
    type: count
  }

  measure: count_with_liquid {
    type: count
    # link: {
    #   label: "Status Count"
    #   url: "https://www.google.com/search?q={{ status._value }}"
    # }
    link: {
    #  label: "{% if row['view_name.field_name'] %} Status Count {% endif %}"
      url: "https://www.google.com/search?q={{ row['view_name.field_name'] }}"
    }
  }

  measure: total_sales_email {
    group_label: "Total Sales from Email Users"
    value_format_name: usd
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_source: "Yes"]
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
