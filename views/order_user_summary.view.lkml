view: order_user_summary {
  # sql_table_name: public.Order_items ;;
  derived_table: {
    sql: SELECT
          order_id
          ,user_id
          ,count(id) as order_item_count
          ,SUM(sale_price) as order_total

      FROM order_items
      GROUP BY order_id,user_id

      ORDER BY order_item_count DESC
       ;;

      # persist_for: "12 hours"

      # sql_trigger_value: SELECT CURRENT_DATE ;;

      datagroup_trigger: order_items_update

  }


  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: order_item_count_total {
    type: sum
    sql: ${TABLE}.order_item_count ;;
  }

  measure: order_total_average {
    type: average
    sql: ${TABLE}.order_total ;;
  }

  set: detail {
    fields: [order_id, user_id, order_item_count_total, order_total_average]
  }
}
