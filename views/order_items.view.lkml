
view: order_items {

  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    hidden: no
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

  dimension_group: shipping_took {
    description: "Duration between shipping and item being delivered"
    type: duration
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
    intervals: [day, month, year]
  }

  dimension: status {
    label: "Order Status"
    type: string
    sql: ${TABLE}.status ;;

    html:
        {% if value == 'Complete' %}
      <b><p style="background-color: #49cec1; margin: 0; border_radius: 5px; text-align:center">{{ value }}</p><b>
    {% elsif value == 'Cancelled' or value == 'Returned' %}
      <b><p style="background-color: #dc7350; margin: 0; border_radius: 5px; text-align:center">{{ value }}</p><b>
    {% else %}
      <b><p style="background-color: #e9b404; margin: 0; border_radius: 5px; text-align:center">{{ value }}</p><b>
    {% endif %};;
  }


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }



  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    #html: <font size="+1"> {{ linked_value }}</font> ;;
  }



  measure: avg_revenue {
    description: "Average of the sale price"
    label: "Average Revenue"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
    drill_fields: [item_detail*]
  }

  measure: count_order {
    type: count_distinct
    sql: ${order_id} ;;
    drill_fields: [item_detail*]
    link: {
      label: "Total sale by month by age group"
      url: "{{link}}&pivots=users.age_group"
    }


  }

  measure: count_returned {
    type: count_distinct
    sql: ${id} ;;
    filters: [status: "Returned"]
    drill_fields: [item_detail*]

    link: {
      label: "Explore top 20 results"
      url: "{{ link }}&sorts=order_items.sale_price+desc&limit=20"

    }

  }


  measure: count {
    type: count
    drill_fields: [item_detail*]
  }



  parameter: date_granularity_selector {
    type: unquoted
    default_value: "created_month"

    allowed_value: {
      value: "created_month"
      label: "Month"
    }

    allowed_value: {
      value: "created_week"
      label: "Week"
    }

    allowed_value: {
      value: "created_date"
      label: "Date"
    }

  }


  dimension: dynamic_timeframe {
    label_from_parameter: date_granularity_selector
    type: string
    sql:
        {% if date_granularity_selector._parameter_value == 'created_date' %}
    ${created_date}
    {% elsif date_granularity_selector._parameter_value == 'created_week' %}
    ${created_week}
    {% else %}
    ${created_month}
    {% endif %} ;;
  }


  dimension: welcome_message {
    type: string
    html:  Welcome {{_user_attributes['first_name']}} ;;
    sql: 1 ;;
  }





  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [

      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

  #-----

  set: item_detail {
    fields: [order_id, status, created_date, sale_price, products.brand, products.name]
  }


}
