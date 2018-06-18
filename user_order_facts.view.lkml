view: user_order_facts {
  derived_table: {
    sql: SELECT
      u.id,count(o.order_id) order_cnt,sum(sale_price) Total_sale_price,min(o.created_at),max(o.created_at)

      from public.users u left join  public.order_items o on u.id=o.id
      group by u.id
       ;;
#        datagroup_trigger:
# distribution: "id"
# sortkeys: ["id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_cnt {
    type: number
    sql: ${TABLE}.order_cnt ;;
  }

  dimension: total_sale_price {
    type: number
    sql: ${TABLE}.total_sale_price ;;
  }

  dimension_group: min {
    type: time
    sql: ${TABLE}.min ;;
  }

  dimension_group: max {
    type: time
    sql: ${TABLE}.max ;;
  }

  set: detail {
    fields: [id, order_cnt, total_sale_price, min_time, max_time]
  }
}
