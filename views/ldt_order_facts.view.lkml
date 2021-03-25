view: ldt_order_facts {
  derived_table: {
    sql: SELECT order_id, user_id, count(*) as item_count
      FROM public.order_items
      GROUP BY 1,2
       ;;
  }


  dimension: order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: item_count {
    type: number
    sql: ${TABLE}.item_count ;;
  }

  measure: average_items_ordered {
    type: average
    sql: ${item_count} ;;
  }


}
