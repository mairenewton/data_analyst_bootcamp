view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    hidden: yes
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


  measure: count_orders {
    label: "Count of Distinct Orders"
    type: count_distinct
    sql: ${order_id} ;;
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



  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: total_sales_email {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: {
      field: users.Paolotrafficcheck
      value: "Yes"
    }
  }


  measure: percent_sales_email {
    type: number
    sql: 1.0*${total_sales_email}/ NULLIF(${total_sales},0) ;;
    value_format_name: percent_1

  }


measure: avg_sale_user {
  type:  number
  value_format_name: usd
  sql: ${total_sales}/NULLIF(${users.count},0) ;;


}


  measure: avg_sales {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
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


  dimension: PaoloShipDays {
    type: number
    sql: DATEDIFF(DAYS,${shipped_date},${delivered_date});;
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
