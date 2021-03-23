view: total_cost_inventory_items_by_sku {
  derived_table: {
    sql: SELECT
        inventory_items.product_sku  AS product_sku,
        COALESCE(SUM(inventory_items.cost ), 0) AS total_cost_for_sku
      FROM public.inventory_items  AS inventory_items

      GROUP BY 1
       ;;
  }
  dimension: inventory_items_product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: inventory_items_total_cost {
    type: number
    sql: ${TABLE}.total_cost_for_sku ;;
  }

  measure: grand_total_cost_for_sku {
    type: sum
    sql: ${inventory_items_total_cost} ;;
  }

  measure: percent_inventory_items_sold {
    type: number
    sql: ${total_cost_goods_sold_by_sku.grand_total_cost_for_sku_items_sold}*1.0/nullif(${grand_total_cost_for_sku},0)  ;;
  }

}
