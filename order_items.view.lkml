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

  dimension: shipping_days {
    type: number
    sql: datediff(days,${shipped_date},${delivered_date}) ;;
  }

  dimension: inventory_item_id {
    type: number
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
    sql: ${TABLE}.user_id ;;
  }

  measure: ordersN {
    type: count_distinct
    sql: ${order_id} ;;
  }


measure: Sales {
  type:  sum
  sql: ${sale_price} ;;
  value_format_name: usd
}

  measure: AvgSales {
    type:  average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

measure: sales_for_emails {
  type:  sum
  sql: ${sale_price} ;;
  value_format_name: usd
  filters: {
    field: users.is_email
    value: "Yes"

  }
}

  measure: Spend_by_user {
    type:  number
    sql: ${Sales}/${users.count} ;;
    value_format_name: usd
  }

measure: email_sales_from_total {
  type:  number
  sql: sum(${sales_for_emails})/sum(${Sales}) ;;
  value_format_name: percent_1
}


parameter: user_measure{
  label: "User Measure"
  type: string
  allowed_value: {
    label:"Total Reveue"
    value:"Total Reveue"}
  allowed_value: {
    label: "TotalProfit"
    value:"Total Profit"}
  allowed_value: {
    label:"ASP"
    value:"ASP"}

}

measure: user_measure_calc {
  label_from_parameter: user_measure
  type: number
  sql:
  case:
  when {% parameter user_measure %}='Total Revenue' then ${Sales}
   when {% parameter user_measure %}='Total Profit' then ${Sales}
  when {% parameter user_measure %}='ASP' then ${AvgSales}
  end
 ;;

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
