view: bootcamp_native_table {

    derived_table: {

      datagroup_trigger: orders_datagroup
      sortkeys: ["order_id"]
      distribution: "order_id"

      explore_source: order_items {
        column: order_id {field: order_items.order_id}
        column: count {field: order_items.count}
        column: total_sales {field: order_items.total_sales}
        derived_column: order_revenue_rank {
          sql:  rank() over(order by total_sales desc) ;;}
       }



    }
    dimension: order_id {
      primary_key: yes
      type: number
    }

    dimension: average_revenue_per_item {
      type: number
      value_format_name: usd
      sql:  ${total_sales}/${count} ;;

    }

    dimension: count {
      type: number
    }
    dimension: total_sales {
      value_format: "$#,##0.00"
      type: number
    }

    dimension: order_revenue_rank {
      type: number
    }

  }
