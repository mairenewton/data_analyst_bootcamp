view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    group_label: "Product Info"
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    group_label: "Product Info"
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    group_label: "Product Info"
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    description: "Average Cost of Item"
    label: "Average Cost"
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }
}
