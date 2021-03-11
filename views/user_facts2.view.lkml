# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

  view: user_facts2 {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: total_sales {}
        column: order_count {}
        derived_column: lifetime_revenue {
          sql: sum(total_sales) ;;

        }
      }
    }
    dimension: id {
      type: number
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: order_count {
      description: "A count of unique orders"
      type: number
    }
  }
