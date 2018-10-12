# If necessary, uncomment the line below to include explore_source.
include: "data_analyst_bootcamp.model.lkml"

#explore: derived_order {}
view: order_facts {
  derived_table: {
    distribution: "order_id"
    sortkeys: ["order_id"]
    datagroup_trigger: order_items

    explore_source: order_items {
      column: order_id { field: order_items.order_id }
      column: order_item_count { field: order_items.order_item_count}
      column: order_sum_total { field: order_items.sum_total}
      derived_column: order_revenue_rank {
        sql: rank() over(order by order_sum_total desc) ;;
      }
      filters: {
        field: users.age
        value: "[18,30]"
      }
    }
  }
  dimension: order_id {
    primary_key: yes
    type: number
    hidden: yes
  }
  dimension: order_item_count {
    description: "count of distinct order items"
    type: number
  }
  dimension: order_sum_total {
    type: number
    value_format_name: usd_0
    #hidden: yes
  }
  dimension: order_revenue_rank {
    type: number
  }
}
