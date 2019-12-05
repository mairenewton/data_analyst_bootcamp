# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: user_order_summary_ndt {
  derived_table: {
    explore_source: order_items {
      column: total_sales {}
      column: count {}
      column: user_id { field: users.id }
      column: first_created {}
      column: state {field:users.state}
      column: inventory_item_id {}
      derived_column: clv_rank {
        sql: rank() over(partition by state order by total_sales desc) ;;
      }
      derived_column: total_city_sale {
        sql: sum(total_sales) over(partition by state ) ;;
      }
    }
  }
  dimension: total_sales {
    value_format_name: gbp
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: user_id {
    type: number
    sql: ${users.id} ;;
  }
  dimension: first_created {
    type: number
  }
  dimension: state {
    type: number
  }

  dimension: inventory_item_id {
    type:  number
  }

  dimension: clv_rank {
    label: "CLV_Rank"
  }
  dimension: total_city_sale {
    type: number
  }

  measure: average_orders {
    type: average
    value_format_name: gbp
    sql: ${total_sales} ;;
  }

}
