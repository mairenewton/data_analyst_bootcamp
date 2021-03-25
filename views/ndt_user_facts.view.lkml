# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: ndt_user_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {field: users.id}
      column: orders {field: order_items.orders}
      column: total_sales {field: order_items.total_sales}
    }
  }
  dimension: user_id {
    type: number
  }
  dimension: orders {
    type: number
  }
  dimension: total_sales {
    value_format: "$#,##0.00"
    type: number
  }
}
