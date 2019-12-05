view: user_order_summary {
  derived_table: {
    datagroup_trigger: users
    sql: SELECT
        users.id  AS "users.id",
        min(order_items.created_at) as min_order_date,
        COUNT(DISTINCT order_items.order_id ) AS "order_items.count_dist_orders",
        COALESCE(SUM(order_items.sale_price ), 0) AS "order_items.total_sales"
      FROM public.order_items  AS order_items
      LEFT JOIN public.users  AS users ON order_items.user_id = users.id
      where {%condition user_region %}users.city {%endcondition%}
      GROUP BY 1
       ;;
    distribution_style: all
  }
  filter: user_region {
    type: string
  }

  dimension: users_id {
    type: number
    hidden: yes
    sql: ${TABLE}."users.id" ;;
  }

  dimension_group: min_order_date {
    type: time
    sql: ${TABLE}.min_order_date ;;
  }

  dimension: customer_lifetime_orders {
    type: number
    sql: ${TABLE}."order_items.count_dist_orders" ;;
  }

  dimension: customer_lifetime_value {
    type: number
    value_format_name: gbp
    sql: ${TABLE}."order_items.total_sales" ;;
  }
  measure: average_orders {
    type: average
    value_format_name: gbp
    sql: ${customer_lifetime_value} ;;
  }

}
