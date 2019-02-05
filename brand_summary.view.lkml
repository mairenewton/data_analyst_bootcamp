view: brand_summary {
  derived_table: {
    sql: SELECT
        products.brand  AS "Brand",
        COUNT(*) AS "order_items.count"
      FROM public.order_items  AS order_items
      LEFT JOIN public.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN public.products  AS products ON inventory_items.product_id = products.id

      GROUP BY 1
       ;;

      persist_for: "24 Hours"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: products_brand {
    type: string
    sql: ${TABLE}."Brand" ;;
  }

  dimension: order_items_count {
    type: number
    sql: ${TABLE}."order_items.count" ;;
  }

  set: detail {
    fields: [products_brand, order_items_count]
  }
}
