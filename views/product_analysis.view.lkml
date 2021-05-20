view: product_analysis {
  view_label: "Product Facts"
  derived_table: {
    sql: SELECT
      product_sku AS product_sku,
      SUM(cost) AS total_cost,
      SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold
      FROM public.inventory_items
      GROUP BY 1 ;;
  }

  # measure: count {
  #   type: count
  #   drill_fields: [detail*]
  # }

  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
    value_format_name: percent_2
  }

  dimension: cost_of_goods_sold {
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
    value_format_name: percent_2
  }

  dimension: percentage_inventory_sold{
    type: number
    sql: ${cost_of_goods_sold} / ${total_cost} ;;
  }

  measure: average_percentage_inventory_old {
    type: average
    sql:  ${percentage_inventory_sold} ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
