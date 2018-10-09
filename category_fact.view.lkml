view: category_fact {
  derived_table: {
    sql: SELECT
        category,
        count(id) as product_count,
        avg(retail_price) as average_retail_price
      FROM public.products
      GROUP BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: category {
    type: string
    primary_key: yes
    sql: ${TABLE}.category ;;
  }

  dimension: product_count {
    type: number
    sql: ${TABLE}.product_count ;;
  }

  dimension: average_retail_price {
    type: number
    sql: ${TABLE}.average_retail_price ;;
  }

  set: detail {
    fields: [category, product_count, average_retail_price]
  }
}
