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

  dimension: order_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count_ {
    label: "Order Count"
    type: number
    sql: ${TABLE}.count ;;
  }

  measure: sum {
    label: "Total Revenue"
    type: sum
    sql: ${TABLE}.sum ;;
  }

  set: detail {
    fields: [order_id, user_id, count_, sum]
  }
}
