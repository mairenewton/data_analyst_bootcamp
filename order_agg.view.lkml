view: order_sizes {
    derived_table: {
      explore_source: order_items {
        column: order_id {field: order_items.order_id}
        column: order_item_ct {field: order_items.order_ct}
        column: order_total {field: order_items.sales_price}
        derived_column: size_rank {
          sql: rank() OVER (ORDER BY order_item_ct desc) ;;
        }
      }
    }
    dimension: order_id {type: number}
    dimension: order_item_ct {type: number}
    dimension: order_total {type: number}
    dimension: size_rank {type: number}
  }
