
  # If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

explore: ndt_order_facts {}

view: ndt_order_facts {
    derived_table: {

    distribution: "order_id"
    sortkeys: ["order_id"]
    datagroup_trigger: order_items_change_datagroup

      explore_source: order_items {
        column: total_sale {}
        column: count {}
        column: order_id {}
        derived_column: order_revenue_rank {
          sql: rank() over (order by total_sale desc) ;;
        }
      }
    }
    dimension: total_sale {
      value_format: "€#,##0.00"
      type: number
    }
    dimension: count {
      label: "Order Items Count"
      type: number
    }
    dimension: order_id {
      type: number
    }

#-------solution-------------------
    measure: avg_order_items_purchased {
      type: average
      sql: ${count} ;;
    }

    measure: avg_order_value {
      type: average
      sql: ${total_sale} ;;
    }

  }
