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

  dimension_group: shipping_days_duration {
    type: duration
    intervals: [day,week]
    sql_start:${created_date}  ;;
    sql_end:${shipped_date} ;;
    drill_fields: [days_shipping_days_duration]
  }


  dimension: shipping_days {
    description: "why we no have prime"
    type: number
    sql:  datediff(day,${shipped_date},${delivered_date}) ;;
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




#####MEASURES######

measure: total_sales_price {
  type: sum
  sql: ${sale_price};;
  value_format_name: gbp
}


measure: sales_email {
  label: "Sales from email source"
  type: sum
  sql:${sale_price} ;;
  filters: [users.traffic_source: "Email "]
}


  measure: avg_sales {
    type: number
    sql: ${total_sales_price}/NULLIF{$users.count},0);;
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: order_count  {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: order_count_shipped  {
    type: count_distinct
    sql: ${order_id} ;;
    filters: [status: "Shipped"]
  }


  measure: total_profit {
    type: number
    sql: ${total_sales_price} - ${inventory_items.total_cost} ;;
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
