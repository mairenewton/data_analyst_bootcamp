view: user_fact {
  derived_table: {
    sql: select
      id
      , count(distinct(order_id)) as total_orders
      , sum(sale_price) as total_revenue
      , min(created_at) as min_created
      , max(created_at) as max_created
      from public.order_items
      group by id
       ;;
      sql_trigger_value: getdate() ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
    primary_key: yes
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension_group: min_created {
    type: time
    sql: ${TABLE}.min_created ;;
  }

  dimension_group: max_created {
    type: time
    sql: ${TABLE}.max_created ;;
  }

  set: detail {
    fields: [id, total_orders, total_revenue, min_created_time, max_created_time]
  }
}
