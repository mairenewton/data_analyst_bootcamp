view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }


  dimension: category_comparator {
    type: string
    sql:
      CASE {% condition choose_a_cat_to_comp %}
        ${category}
        {% endcondition %}
        THEN ${category}
        ELSE 'All other categories'
        END
        ;;
  }

  filter: choose_a_cat_to_comp {
    type: string
    suggest_explore: inventory_items
    suggest_dimension: products.category
  }


  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
