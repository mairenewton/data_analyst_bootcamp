view: product_inventory_facts_sdt {
  derived_table: {
    sql: SELECT
       product_sku,
       SUM(cost) AS total_cost,
       SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold
      FROM public.inventory_items
      GROUP BY product_sku
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
  }


  dimension: cost_of_goods_sold {
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  dimension: percentage_of_inventory_sold {
    type: number
    value_format_name: percent_2
    sql: ${cost_of_goods_sold}/${total_cost} ;;
  }

  measure: average_percent_of_inventory_sold {
    type: average
    sql: ${percentage_of_inventory_sold} ;;
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
