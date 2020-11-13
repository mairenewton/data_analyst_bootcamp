view: order_facts {
  derived_table: {
    sql: SELECT
        inventory_items.product_sku,
        SUM(CASE WHEN inventory_items.sold_at IS NOT NULL THEN inventory_items.cost ELSE 0 END) AS total_costs_sold,
        SUM(inventory_items.cost) AS total_costs
      FROM public.inventory_items
      GROUP BY product_sku
       ;;
    distribution: "order_id"
    sortkeys: ["order_id"]
    datagroup_trigger: order_items_datagroup
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: product_sku {
    type: string
    primary_key: yes
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_costs_sold {
    type: number
    sql: ${TABLE}.total_costs_sold ;;
  }

  dimension: total_costs {
    type: number
    sql: ${TABLE}.total_costs ;;
  }

  dimension: percentage_inventory_sold {
    type: number
    sql: 1.00 * ${total_costs_sold} / NULLIF(${total_costs},0) ;;
    value_format_name: percent_2
  }

  measure: average_percentage_inventory_sold {
    type: average
    sql: ${percentage_inventory_sold} ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [product_sku, total_costs_sold, total_costs]
  }
}
