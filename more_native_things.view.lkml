include: "data_analyst_bootcamp.model.lkml"
view: more_native_things {
  derived_table: {
    explore_source: order_items {
      column: id { field: order_items.order_id }
      column: total_sales {}
      column: distinct_orders {}
      derived_column: order_revenue_rank {
        sql: rank() over(order by total_sales desc) ;; }
    }
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.total_sales ;;
  }

  dimension: distinct_orders {
    type: number
    sql: ${TABLE}.distinct_orders ;;
  }

}
