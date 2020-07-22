view: user_facts_sql {
  derived_table: {
    datagroup_trigger: default_current_date
    distribution: "user_id"
    sortkeys: ["user_id"]
    sql: select
      user_id,
      sum(sale_price) as LTValue,
      count(distinct order_id) as LTOrderCount
      from order_items
      group by 1
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

  dimension: ltvalue {
    type: number
    sql: ${TABLE}.ltvalue ;;
  }

  dimension: ltordercount {
    type: number
    sql: ${TABLE}.ltordercount ;;
  }

  set: detail {
    fields: [user_id, ltvalue, ltordercount]
  }
}
