
include: "/models/data_analyst_bootcamp.model.lkml"

  view: monthly_profitability_summary {
    derived_table: {
      explore_source: order_items {
        column: created_month {}
        column: total_sales {}
        column: order_count {}
        derived_column: total_profit_per_item {
          sql: total_sales/order_count ;;
        }
        derived_column: total_profit_per_item_last_year {
          sql: lag(total_sales/order_count,12) OVER (order by created_month asc) ;;
        }
      }
    }

    dimension: created_month {
      primary_key: yes
      type: date_month
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_count {
      description: "A count of unique orders"
      type: number
    }

    dimension: total_profit_per_item {
      type: number
      value_format_name: usd
    }

    dimension: total_profit_per_item_last_year {
      type: number
      value_format_name: usd
    }

  }
