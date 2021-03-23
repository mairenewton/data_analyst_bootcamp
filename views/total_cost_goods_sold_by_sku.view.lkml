view: total_cost_goods_sold_by_sku {
  derived_table: {
    sql: SELECT
        inventory_items.product_sku ,
        sum(inventory_items.cost) total_cost_for_sku_items_sold
      FROM public.order_items  AS order_items
      LEFT JOIN public.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      group by 1
       ;;

    datagroup_trigger: default
    indexes: ["product_sku"]
    distribution_style: even
  }

  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_cost_for_sku_items_sold {
    type: number
    sql: ${TABLE}.total_cost_for_sku_items_sold ;;
  }

  measure: grand_total_cost_for_sku_items_sold {
    type: sum
    sql: ${total_cost_for_sku_items_sold} ;;
  }


}
