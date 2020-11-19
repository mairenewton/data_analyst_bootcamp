view: dt_order_facts {
  derived_table: {
    sql: select order_id,
      user_id ,
      count(*) as item_count,
      sum(sale_price) as revenue
  from order_items
  group by 1,2
 ;;

  datagroup_trigger: default
  indexes: ["order_id"]
  distribution_style: even
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

  dimension: item_count {
    hidden: yes
    type: number
    sql: ${TABLE}.item_count ;;
  }

  dimension: revenue {
    hidden: yes
    type: number
    sql: ${TABLE}.revenue ;;
  }

  measure: average_item_count {
    type: average
    sql: ${item_count} ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }

  measure: total_revenue {
    type: sum
    sql: ${revenue} ;;
    value_format_name: usd
  }

  set: detail {
    fields: [order_id, user_id, item_count, revenue]
  }
}
