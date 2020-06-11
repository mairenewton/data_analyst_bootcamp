
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
# If necessary, uncomment the line below to include explore_source.
 include: "/models/data_analyst_bootcamp.model"

  view: user_test {
    derived_table: {
      explore_source: order_items {
        column: user_id {}
        column: count {}
        column: created_month {}
      }
    }
    dimension: user_id {
      type: number
    }
    dimension: count {
      type: number
    }
    dimension: created_month {
      type: date_month
    }
  }
