view: inventory_facts {
  derived_table: {
    sql: SELECT product_sku,
        sum(cost) as total_cost,
        sum(case when sold_at is NOT NULL then cost ELSE null END) as cost_of_goods_sold
      FROM public.inventory_items
      GROUP BY 1
       ;;
  }



  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.total_cost ;;
  }

  dimension: cost_of_goods_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
  }

  measure: total_cogs {
    type: sum
    sql: ${cost_of_goods_sold} ;;
  }

  measure: percentage_of_inv_sold {
    type: number
    sql: 1.0* ${cost_of_goods_sold} / NULLIF(${cost},) ;;
    value_format_name: usd
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
