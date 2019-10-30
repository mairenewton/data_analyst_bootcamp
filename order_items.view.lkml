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

  measure: total_rev {
    type: sum
    sql: ${TABLE}.sale_price ;;
    label: "Total Price"
    description: "SUM of Sale Price"
    value_format_name: usd
  }

  measure: avg_item_price{
    type:  average
    sql: ${TABLE}.sale_price ;;
    label: "Average item Price"
    description: "Average of Sale Price"
    value_format_name: usd
  }

  dimension: buying_customer{
    type: yesno
    sql: ${TABLE}.user_id ;;
    label: "Buying Customer"
    description: "Buying Customer Flag"
  }

  measure: customer_count{
    type:  count_distinct
    sql: ${TABLE}.user_id ;;
    label: "Count of users"
    description: "Count of users"
  }

  dimension: date_diff {
    type: duration_day
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
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
