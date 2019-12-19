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

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
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

  # xue
  measure: shipping_days{
    type: number
    sql: DATEDIFF(d, ${shipped_date},${delivered_date} ) ;;
  }
  measure: count_order_xue {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
  }
  measure: total_sale_xue {
    type: sum
    sql: ${sale_price} ;;
  }
  measure: average_sale_xue {
    type: average
    sql: ${sale_price} ;;
  }
  measure: total_sale_email {
    type: sum
    sql: ${sale_price};;
    filters: {
      field: users.is_email
      value: "yes"
    }
  }
  measure: percentage_email {
    type: number
    sql: 1.0*(${total_sale_email}/nullif(${total_sale_xue},0));;
    value_format_name: percent_0
  }
  measure: count_user {
    type: count_distinct
    sql: ${user_id} ;;
  }
  measure: avarage_spend_per_user {
    type: number
    sql: 1.0*${total_sale_xue}/nullif(${count_user}) ;;
    value_format_name: usd
  }
}
