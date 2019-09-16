# If necessary, uncomment the line below to include explore_source.
# include: "data_analyst_bootcamp.model.lkml"

view: user_orders_fact_ndt{
  derived_table: {
#     datagroup_trigger: count_order_items
#     distribution: "user_id"
#     sortkeys: ["user_id"]
  explore_source: order_items {
    column: user_id {}
    column: count_order {}
    column: sale_price_total {}
    column: min_created_date {}
    column: max_created_date {}
    bind_filters: {
      from_field: order_items.status
      to_field:order_items.status
    }
    bind_filters: {
      from_field: order_items.created_date
      to_field:order_items.created_date
    }
    bind_filters: {
      from_field: user_orders_fact_ndt.user_name_filter_only
      to_field:users.first_name
    }
    derived_column: customer_date_rank {
      sql: rank() over (order by min_created_date asc) ;;
    }
  }
}

dimension: customer_date_rank {
  type: number
}

dimension: first100 {
  type: yesno
  sql: ${customer_date_rank} <= 100;;
}

filter: user_name_filter_only {
  type: string
  suggest_explore: order_items
  suggest_dimension: users.first_name
}

dimension: user_id {
  type: number
  primary_key: yes
  hidden: yes
}

dimension: lifetime_orders {
  type: number
  sql: ${TABLE}.count_order ;;
}

dimension: lifetime_revenue {
  value_format: "$#,##0.00"
  type: number
  sql: ${TABLE}.sale_price_total ;;
}

dimension: order_count_bucket {
  type: tier
  sql: ${lifetime_orders};;
  tiers: [0,10,20,50]
}

dimension_group: first_order {
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql:  ${TABLE}.min_created_date;;
}

dimension_group: last_order {
  type: time
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql:  ${TABLE}.max_created_date;;
}
}
