view: users_explore {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: order_count {}
        column: total_sales {}
#         bind_all_filters: yes
      }
    }
    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }
    dimension: order_item_count {
      type: number
      sql: ${TABLE}.order_count ;;
    }
    dimension: total_sale_price {
#       value_format: "$#,##0.00"
      type: number
      sql: ${TABLE}.total_sales ;;
    }
    measure: average_order_item_count {
      type: average
      sql: ${TABLE}.order_count ;;
    }
    measure: average_total_sale_price {
#       value_format: "$#,##0.00"
      type: average
      sql: ${TABLE}.total_sales ;;
  }

  }
