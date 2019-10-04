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

  dimension: shippingDays {
    type: number
    sql: ${delivered_date}-${shipped_date} ;;
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

  measure: UniqueOrders {
    type: count_distinct
    sql:  ${order_id} ;;
      }

  measure: TotalSales {
    type: sum
    sql:  ${sale_price} ;;
  }


  measure: AvregaeSales {
    type: average
    sql:  ${sale_price} ;;
  }


  measure: TotalSales_Email {
    type: sum
    sql:  ${sale_price} ;;
    filters: {
      field: users.traffic_source
      value: "Email"}
  }

 measure: percentage_email_sales {

  type: number
  value_format_name: percent_1
  sql: 1.0*${TotalSales_Email}
    /NULLIF(${TotalSales}, 0) ;;
}

  measure: total_users {
    type: count_distinct
    sql: ${user_id}   ;;
  }


  measure: avg_spend_ {
    type: number
    value_format_name: decimal_0
    sql: ${TotalSales}
      /NULLIF(${total_users}, 0) ;;
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
