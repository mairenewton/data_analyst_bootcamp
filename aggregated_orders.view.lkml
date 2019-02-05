view: aggregated_orders {
  derived_table: {
    sql: SELECT
        order_items.user_id  AS "User ID",
        COUNT(*) AS "Lifetime Order Count",
        DATE(MIN((DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.created_at )))) ) AS "First Ever Order",
        DATE(MAX((DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', order_items.created_at )))) ) AS "Most Recent Order",
        COALESCE(SUM(order_items.sale_price ), 0) AS "Total Sales"
      FROM public.order_items  AS order_items

      GROUP BY 1
       ;;

    #different ways to refresh data
    #persist_for: "24 Hours"
    #sql_trigger_value: select max(created_at) from public.order_items ;;
    #datagroup_trigger: data_analyst_bootcamp_default_datagroup
    #indexes: ["id"] #for interleaved - flixeible indexes
    #sortkeys:[] #for compund sortkeys
    #distribution "all" $good for small lookup tables
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_items_user_id {
    type: number
    sql: ${TABLE}."User ID" ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."Lifetime Order Count" ;;
  }

  dimension: order_items_first_order_date {
    type: date
    sql: ${TABLE}."First Ever Order" ;;
  }

  dimension: order_items_most_recent_order_date {
    type: date
    sql: ${TABLE}."Most Recent Order" ;;
  }

  dimension: order_items_sum_of_sales {
    type: number
    sql: ${TABLE}."Total Sales" ;;
    value_format: "$0.00"
  }

  set: detail {
    fields: [order_items_user_id, order_items_count, order_items_first_order_date, order_items_most_recent_order_date, order_items_sum_of_sales]
  }
}
