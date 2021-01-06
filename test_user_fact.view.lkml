view: test_user_fact {
  derived_table: {
    sql: select user_id,
      sale_price
      from public.order_items
      limit 10
       ;;

  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  set: detail {
    fields: [user_id, sale_price]
  }
}
