view: user_facts {
  derived_table: {
    sql: select order_items.user_id,
        count(distinct order_items.id) as order_count,
        sum(order_items.sale_price) as sales_total
      from order_items
      group by user_id
       ;;
  }


  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  #added
  measure: average_lifetime_value {
    type: average
    value_format_name: usd
    sql: ${sales_total} ;;
  }

  #added
  measure: average_lifetime_order_count {
    type: average
    value_format_name: decimal_0
    sql: ${order_count} ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }

  dimension: sales_total {
    type: number
    sql: ${TABLE}.sales_total ;;
  }

  set: detail {
    fields: [user_id, order_count, sales_total]
  }
}
