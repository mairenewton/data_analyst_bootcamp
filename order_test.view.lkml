view: sql_runner_query {
  derived_table: {
    sql: SELECT * FROM thelook_events.INVENTORY_ITEMS LIMIT 10
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}.PRODUCT_ID ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension_group: sold_at {
    type: time
    sql: ${TABLE}.SOLD_AT ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.COST ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.PRODUCT_CATEGORY ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.PRODUCT_NAME ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.PRODUCT_BRAND ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.PRODUCT_RETAIL_PRICE ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.PRODUCT_DEPARTMENT ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.PRODUCT_SKU ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.PRODUCT_DISTRIBUTION_CENTER_ID ;;
  }

  set: detail {
    fields: [
      id,
      product_id,
      created_at_time,
      sold_at_time,
      cost,
      product_category,
      product_name,
      product_brand,
      product_retail_price,
      product_department,
      product_sku,
      product_distribution_center_id
    ]
  }
}
