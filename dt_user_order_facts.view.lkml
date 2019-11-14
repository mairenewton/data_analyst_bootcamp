view: dt_user_order_facts {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "order_items.user_id",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_sale_price"
      FROM public.order_items  AS order_items

      GROUP BY 1
      ORDER BY 2 DESC
       ;;
      distribution_style: all
      datagroup_trigger: order_items_update

  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."order_items.user_id" ;;
  }

  dimension: order_items_total_sale_price {
    hidden: yes
    type: number
    sql: ${TABLE}."order_items.total_sale_price" ;;
  }

  measure: total_lifetime_value {
    type: sum
    sql: ${order_items_total_sale_price} ;;
    value_format_name: usd_0
  }
  measure: average_lifetime_value {
    type: average
    sql: ${order_items_total_sale_price} ;;
    value_format_name: decimal_2
  }

  set: detail {
    fields: [order_items_user_id, order_items_total_sale_price]
  }
}
