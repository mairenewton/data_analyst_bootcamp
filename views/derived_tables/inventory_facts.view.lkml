explore: inventory_facts {}

view: inventory_facts {
  derived_table: {
    sql: SELECT inventory_items.product_sku AS product_sku
        ,SUM(inventory_items.cost) AS total_cost
        ,SUM(CASE WHEN inventory_items.sold_at is not null THEN inventory_items.cost ELSE NULL END) AS cost_of_goods_sold
        ,cost_of_goods_sold/NULLIF(total_cost,0) AS percent_inventory_sold
      FROM public.inventory_items
      GROUP BY product_sku
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
    primary_key: yes
  }


  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
  }

  dimension: cost_of_goods_sold {
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  dimension: percent_inventory_sold {
    type: number
    sql: ${TABLE}.percent_inventory_sold ;;
    value_format_name: percent_2
  }

  measure: avg_percent_inventory_sold {
    type: average
    sql: ${percent_inventory_sold} ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold, percent_inventory_sold]
  }
}
