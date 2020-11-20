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

  dimension: shipping_days {
    type: number
    sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
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

  measure: nbr_orders_distinct {
    type: count_distinct
    sql: ${order_id} ;;
    }

  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sales {
    label: "count of unique orders"
    description: "this is a count distinct of the unique orders"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_new_users {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    filters: [users.is_new_customer: "Yes"]
  }

  measure: total_sales_email {
    label: "Total sales for only users that came to the website via Email"
    type: sum
    sql: ${sale_price};;
    filters: [users.mail: "Yes"]
    # filters: [user.traffic_source: "Email"] -- same
  }

  measure: pc_sales_mail {
    label: "Percentage of sales that are attributed to users coming from the email traffic source."
    type:  number
    sql: 1.0 * ${total_sales_email}/NULLIF(${total_sales}, 0) ;;
  }

  measure: average_sales_per_user {
    type: number
    sql: 1.0*${total_sales}/ NULLIF(${users.count}, 0) ;;
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
