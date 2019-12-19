
  #explore: orders_facts {}
  view: orders_facts {

    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {field:order_items.count}
        column: order_total_revenue {field:order_items.total_sales}
        derived_column: order_revenue_rank{
          sql: rank() over (partition by order_id order by order_total_revenue desc) ;;
        }
      }
    }
    dimension: order_id {
      primary_key: yes
      type: number
      hidden: yes
    }
    dimension: order_item_count {
      label: "Order Item Count"
      type: number
    }
    dimension: order_total_revenue {
      label: "Order Total Revenue"
      value_format: "$#,##0.00"
      type: number
    }

    dimension: avg_rev_per_item {
      type: number
      sql: ${order_total_revenue}/nullif(${order_item_count},0) ;;
      value_format_name: usd
    }

    dimension: order_revenue_rank {
      type: number
    }
  }
