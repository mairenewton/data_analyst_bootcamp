view: orders  {
  derived_table: {
    sql: SELECT
        order_items.order_id  AS order_id,
        users.id  AS users_id,
        sum(order_items.sale_price)  AS order_price,
        COUNT(*) AS order_count
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id

      GROUP BY 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.users_id ;;
  }

  dimension: basket_price {
    type: number
    value_format_name: gbp
    sql: ${TABLE}.order_price ;;
  }

  dimension: basket_count {
    type: number
    sql: ${TABLE}.order_count ;;
  }
  measure: average_price {
    type: average
    value_format_name: gbp
    sql: ${basket_price} ;;
  }

  measure: average_count {
    type: average
    sql: ${basket_count} ;;
  }

  set: detail {
    fields: [order_id, users_id, basket_price, basket_count]
  }
}
