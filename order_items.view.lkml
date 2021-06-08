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
    hidden: yes
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



  # SHIPPING DAYS

  dimension_group: shipping_days {
    type: duration
    sql_start: ${shipped_date};;
    sql_end: ${delivered_date};;
    intervals: [day]
  }

  dimension: shipping_days {
    type: number
    sql: DATEDIFF(day, ${shipped_date}  ,${delivered_date});;
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # COUNT OF UNIQUE ORDERS

  measure: order_count {
    description: "A count of unique orders"
    type:count_distinct
    sql: ${order_id};;
  }



  # TOTAL SALES

  measure: total_revenue{
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }




  # AVERAGE SALES


  measure: average_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }


  # TOTAL SALES EMAIL USERS

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_source: "Yes"]
  }



  # Percentage of sales that are attributed to users coming from the email traffic source

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}
      /NULLIF(${total_revenue}, 0) ;;
  }



  # Average spend per user by dividing the total sales measure by the user count measure

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0*${total_revenue} / NULLIF(${users.count},0)
      ;;
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
