view: user_facts {
  derived_table: {
    sql: select id,
      sum(sale_price) as total_sale_value
      ,count(distinct order_id) as total_orders
      from order_items
      group by id
       ;;
  }


  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    hidden:  yes
  }

  dimension: total_sale_value {
    type: number
    sql: ${TABLE}.total_sale_value ;;
    hidden:  yes
    }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
    hidden:  yes
    }

measure: average_lifetime_value {
  type: average
  sql:  $(${total_orders}) ;;
  value_format: "usd"
}
  set: detail {
    fields: [id, total_sale_value, total_orders]
  }
}
