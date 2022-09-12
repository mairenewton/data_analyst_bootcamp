#comments
view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    html: <a href="mailto:name@rapidtables.com">Send mail</a> ;;
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
    value_format: "@{usd_1}"
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
    hidden: yes
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_new_users {
    description: "Total revenue by users who signed up in the last 90 days"
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_new_customer: "Yes"]

  }

  measure: count_order_items_last_2_weeks {
    type: count_distinct
    sql: ${order_item_id} ;;
    filters: [created_date: "14 days", status: "-Returned, -Cancelled"]
  }




  measure: total_revenue {
   type: sum
  value_format_name: usd
    sql: ${sale_price} ;;
    drill_fields: [detail*]
    html: <font size= "+1">{{linked_value}}</font> ;;
  }



  measure: avg_revenue {
    description: "Average of the sale price"
    label: "Average Revenue"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: count_users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: count_orders {
    description: "Count of orders"
    drill_fields: [created_month, users.age_group, total_revenue]
    link: {
      label: "Total Sale Price by month by age Tier"
      url: "{{link}}&pivots=users.age_group"
    }
    type: count_distinct
    sql: ${order_id} ;;
  }


  measure: count_items_ordered {
    description: "Count of order items"
    type: count
    drill_fields: [detail*]
  }

  measure: count_returned {
    type: count_distinct
    sql: ${order_item_id} ;;
    filters: [status: "Returned"]
    drill_fields: [returned_detail*]
    link: {
      label: "Explore Top 20 Results"
      url: "{{ link }}&sorts=order_items.sale_price+desc&limit=20"
    }
  }


set: returned_detail {
  fields: [
    order_id,
    status,
    created_date,
    sale_price,
    products.brand,
    products.name
    ]
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
