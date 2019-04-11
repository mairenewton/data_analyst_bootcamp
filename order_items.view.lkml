view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: ordercount {
    type: count_distinct
    value_format_name: decimal_0
    sql:  ${order_id};;
  }

  measure: totalsales {
    type: sum
    value_format_name: gbp_0
    sql:  ${sale_price};;
  }

  measure: percentageofsales {
    type: number
    value_format_name: percent_0
    sql: 1.0*${totalsalesforemailtraffic}/NULLIF(${totalsales},0) ;;
  }

  measure: averagespendperuser {
    type: number
    value_format_name: usd_0
    sql: 1.0*${totalsales}/NULLIF(${users.userscount},0) ;;
  }

  measure: totalsalesforemailtraffic {
    type: sum
    value_format_name: gbp_0
    sql: ${sale_price} ;;
    filters: {
      field: users.is_emailornot
      value: "Yes"
    }
  }

    measure: averagesales {
    type: average
    value_format_name: gbp_0
    sql:  ${sale_price};;
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

  dimension: shippingDays {
    type: number
    sql: datediff(day,${shipped_date},${delivered_date}) ;;
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
