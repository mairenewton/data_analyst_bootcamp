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

  dimension: Ship_days {
    type:  duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;


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

  measure: total_sales_prices  {
    type:  sum
    sql: ${sale_price} ;;
    description: "Total Sales Field "

  }


  measure: total_sales_prices_email_traffic  {
    type:  sum
    sql: ${sale_price} ;;
    filters: {
      field: users.traffic_source_email
      value: "Yes"
    }
    description: "Total Sales for Email Traffic Source "
  }

  measure: percent_sales_email  {
    type:  number
    sql: 100*${total_sales_prices_email_traffic}/Nullif(${total_sales_prices},0) ;;
    description: "Percentage of Sales coming from Email Traffic Source "

  }


  measure: average_sales_prices  {
    type:  average
    sql: ${sale_price} ;;
    description: "Average Sales Field "

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

  measure: order_count{
    type: count_distinct
    sql: ${order_id} ;;

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
