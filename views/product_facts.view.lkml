view: product_facts {
  derived_table: {
    sql: SELECT
   product_sku AS product_sku
  ,SUM(cost) AS total_cost
,SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold
, SUM(cost) / SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) as percentage_sold_vs_total
FROM public.inventory_items
GROUP BY 1
 ;;
datagroup_trigger: order_items_update
  }

  dimension: product_sku {primary_key:yes}
  measure: total_cost {type: sum}
  measure: cost_of_goods_sold  {type: sum}
  measure: percentage_sold_vs_total  {type: average}

}
