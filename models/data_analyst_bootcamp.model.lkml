connection: "events_ecommerce"

# include all the views
include: "/views/*.view"
include: "/views/derived_tables/*.view"
# added comment

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


## BRAD Adds
datagroup: default_midnight_daily {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}
datagroup: order_items_4_hrs {
  sql_trigger:  select max(created_at) from order_items ;;
  max_cache_age: "4 hours"
}

persist_with: data_analyst_bootcamp_default_datagroup
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {

  persist_with: order_items_4_hrs

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  ## BRAD Add

  join: brand_order_facts_ndt {
    type:  left_outer
    sql_on:  ${products.brand} = ${brand_order_facts_ndt.brand} ;;
    relationship: one_to_one
  }

  # sql_always_where:  ${order_items.returned_date} IS NULL;;
  # sql_always_having:  ${order_items.total_sales} > 200 ;;

  # sql_always_where: ${order_items.status} = 'Complete' AND  ${order_items.returned_date} IS NULL ;;
  # sql_always_having:  ${order_items.count} > 5 AND ${order_items.total_sales} > 200;;

  # always_filter: {
  #   filters: [ order_items.created_date: "before today" ]
  # }
  # conditionally_filter: {
  #   filters: [ order_items.created_date: "last 2 years" ]
  #   unless: [ user_id ]
  # }

  # always_filter: {
  #   filters: [order_items.created_date: "last 30 days"] }

  # conditionally_filter: {
  #   filters: [ order_items.]
  # }

  # aggregate_table: item_totals {
  #   query: {
  #     dimensions: [order_items.order_id, order_items.count, order_items.sale_price]
  #     }
  # }

}

## BRAD add

# explore: products {}

explore: users {
  # persist_with: default_midnight_daily
  join: order_items {
    type:  left_outer
    sql_on:  ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }

  join: order_facts_v2 {
    type:  left_outer
    sql_on:  ${users.id} = ${order_facts_v2.user_id} ;;
    relationship: one_to_one
  }

  join: order_facts_v3 {
    type:  left_outer
    sql_on:  ${users.id} = ${order_facts_v3.user_id} ;;
    relationship: one_to_one
  }


}
