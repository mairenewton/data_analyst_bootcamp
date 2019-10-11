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

  dimension_group: daysDiff {
    type: duration
    intervals: [day ,week, year]
    sql_start: ${TABLE}.shipped_at ;;
    sql_end: ${TABLE}.delivered_at ;;
  }

  measure: distinctOrderCount
  {
    type: count_distinct
    sql: ${order_id};;
  }

  measure: totalSalesForEmail
  {
    type:  sum
    value_format_name:  usd
    filters:  {
      field: users.yesno_traffic_source
      value: "Yes"
      }
    sql:  ${sale_price} ;;
  }

  measure: totalSales
  {
    type:  sum
    value_format_name:  usd
    sql:  ${sale_price} ;;
  }

  measure: SalesPercentageForEmail
  {
    type:  number
    value_format_name:  percent_0
    sql:  ${totalSalesForEmail}/${totalSales} ;;
  }

  measure:  averageSpendPerUser
  {
    type:  number
    value_format_name: usd
    sql: ${totalSales}/${users.count} ;;

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
