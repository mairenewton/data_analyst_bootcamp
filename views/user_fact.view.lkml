view: user_fact {
  derived_table: {
    sql: SELECT
        order_items.user_id AS user_id
        ,COUNT(distinct order_items.order_id) AS lifetime_order_count
        ,SUM(order_items.sale_price) AS lifetime_revenue
      ,MIN(order_items.created_at) AS first_order_date
      ,MAX(order_items.created_at) AS latest_order_date
      FROM order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
view: user_fact_ndt {
# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"
    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: avg_spend_per_user {}
        column: latest_order_date_date { field: user_fact.latest_order_date_date }
        column: first_order_date_date { field: user_fact.first_order_date_date }
      }
    }
    dimension: order_id {
      type: number
    }
    dimension: avg_spend_per_user {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: latest_order_date_date {
      type: date
    }
    dimension: first_order_date_date {
      type: date
    }
}
