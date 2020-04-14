view: product_sku_product_facts_sdt {
  view_label: "Products"
  derived_table: {
    sql: SELECT
      product_sku AS product_sku
      ,SUM(cost) AS total_cost
      ,SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS
      cost_of_goods_sold
      FROM public.inventory_items
      GROUP BY 1
       ;;
  }

  dimension: percentage_inventory_sold {
    type:  number
    value_format_name: percent_1
    sql: 1.0 * ${cost_of_goods_sold} / NULLIF(${total_cost},0) ;;
  }

  measure: average_measure {
    type:  average
    value_format_name: percent_1
    sql:  ${percentage_inventory_sold} ;;
  }

  measure: psku_count {

    type: count
    drill_fields: [detail*]
  }

  dimension: product_sku {
    hidden: yes
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

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
