connection: "events_ecommerce"

# include all the views
include: "/views/*.view"


# datagroup: data_analyst_bootcamp_default_datagroup {
#   # sql_trigger: SELECT MAX(id) FROM etl_log;;
#   sql_trigger:
#   max_cache_age: "1 hour"
# }

datagroup: default_dg {
  sql_trigger: select current_date ;;
  max_cache_age: "24 hours"
}

datagroup: order_items_dg {
   sql_trigger: SELECT MAX(create_ts) FROM order_items;;
  max_cache_age: "4 hours"
}

persist_with: default_dg
###change

### Whitespaces ####

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  persist_with: order_items_dg
  # #1
  # # sql_always_where: ${order_items.returned_date} IS NULL ;;

  # # sql_always_having: ${order_items.total_sales} > 200 ;;

  # #2
  # sql_always_where: ${order_items.status} = 'Complete' ;;

  # sql_always_having: ${order_items.count} > 5 ;;

  #3
  # conditionally_filter: {
  #   filters: {
  #     field: order_items.created_date
  #     value: "last 2 years"
  #   }
  #   unless: [users.state]
  # }

  #4
  # always_filter: {
  #   filters: {
  #     field: order_items.created_date
  #     value: "last 30 days"
  #   }
  # }



  #group_label: "Developer Bootcamp"
  #label: "Training Order Items"
  #view_label: "Something Else"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    #fields: [users.show_in_order_items*]
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    #fields: [inventory_items.cost]
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

  join: orders {
    type:  inner
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
  }

  join: user_facts {
    type: inner
    sql_on:  ${users.id} = ${user_facts.user_id} ;;
    relationship: one_to_one
  }

  join: brand_order_facts_ndt {
    type: inner
    sql_on: ${products.brand}=${brand_order_facts_ndt.brand} ;;
    relationship: one_to_one
  }
}




explore: users {
  group_label: "Data Analyst Bootcamp 2"
  # always_filter: {
  #   filters: {
  #     field: order_items.created_date
  #     value: "before today"
  #   }
  # }

  #4
  conditionally_filter: {
    filters: {
      field: users.created_date
      value: "last 90 days"
      }
  unless: [users.id, users.state]
}

  join: order_items {
    type: left_outer
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
    fields: [-order_items.profit]
  }
 }

# Place in `data_analyst_bootcamp` model
explore: +order_items {
  aggregate_table: rollup__created_date__products_brand {
    query: {
      dimensions: [created_date, products.brand]
      measures: [total_sales]
      timezone: "UTC"
    }

    materialization: {
      datagroup_trigger: order_items_dg
    }
  }
}


#explore: orders {}

# explore: products {}
