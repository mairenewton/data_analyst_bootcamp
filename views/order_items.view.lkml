view: order_items {
  sql_table_name: public.order_items ;;

  #view_label: "Order Items different label"

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

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
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

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.is_email_source: "Yes"]
  }

  measure: total_sales_email_users2 {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.traffic_source: "Email"] }


  measure: percent_of_total_orders {
    type: percent_of_total
    sql: ${count} ;;
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: order_count {
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: order_item_count {
    type: count
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0*${total_sales} / NULLIF(${users.customer_count},0)
      ;;
  }


##testing stuff
dimension: random_number {
  type: number
  view_label: "zz Testing Stuff"
  sql: random() ;;
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
