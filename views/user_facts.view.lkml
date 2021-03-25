view: user_facts {
  derived_table: {
    sql: SELECT user_id,
        SUM(sale_price) as lifetime_sales,
        COUNT(*) as lifetime_order_items,
        COUNT(DISTINCT order_id) as lifetime_orders,
        MIN(created_at) as first_order_date,
        MAX(created_at) as latest_order_date
      FROM public.order_items
      GROUP BY 1
       ;;
  }


  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  dimension: lifetime_order_items {
    type: number
    sql: ${TABLE}.lifetime_order_items ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: first_order_date {
    type: time
    timeframes: [raw]
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    timeframes: [raw]
    sql: ${TABLE}.latest_order_date ;;
  }


}
