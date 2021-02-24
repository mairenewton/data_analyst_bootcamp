view: order_facts {
  derived_table: {
    sql: select
        order_id,
        user_id,
        count(*),
        sum(sale_price)
      from order_items
      group by 1,2
      order by 3 desc
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension: count_ {
    type: number
    sql: ${TABLE}.count ;;
  }

  measure: sum {
    type: sum
    sql: ${TABLE}.sum ;;
  }

  set: detail {
    fields: [order_id, user_id, count_, sum]
  }
}
