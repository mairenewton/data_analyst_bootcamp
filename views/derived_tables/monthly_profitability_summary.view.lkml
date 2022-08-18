explore: monthly_profitability_summary {}

# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: monthly_profitability_summary {
  derived_table: {
    explore_source: order_items {
      column: created_month {}
      column: total_profit {}
      column: count {}

#-------solution-------------------
      derived_column: total_profit_per_item {
        sql: total_profit / nullif(count,0) ;;
      }
      derived_column: total_profit_per_item_last_year {
        sql: lag(total_profit/count, 12) OVER(order by created_month asc);;
      }

    }
  }
  dimension: created_month {
    type: date_month
  }
  dimension: total_profit {
    type: number
    value_format_name: "eur"
  }
  dimension: count {
    label: "Count Order Items"
    type: number
  }

  dimension: total_profit_per_item {
    type: number
    value_format_name: "eur"
  }

  dimension: total_profit_per_item_last_year {
    type:  number
    value_format_name: "eur"
  }

#-------solution-------------------

  measure: avg_profit_per_order {
    type: average
    sql: ${total_profit_per_item} ;;
    value_format_name: "eur"

  }

}
