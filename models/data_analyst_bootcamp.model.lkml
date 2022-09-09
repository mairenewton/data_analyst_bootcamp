connection: "events_ecommerce"

# include all the views
include: "/views/*.view"

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger:  SELECT MAX(completed_at) from etl_jobs ;;
  max_cache_age: "1 hour"
}


explore: orders_and_sales_per_user {
  join: users {
    type: left_outer
    sql_on: ${users.id}=${orders_and_sales_per_user.user_id} ;;
    relationship: one_to_many
  }
}

persist_with: data_analyst_bootcamp_default_datagroup



explore: order_items {

  #sql_always_where: ${status} ='Returned! ;;
  #sql_always_having: ${order_items_total_sales} '>200' ;;
  #always_filter: {}

  description: "this provide more info about the explore"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
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
  #always_filter: {
   # filters: [order_items.status: "Returned",order_items.Total_sales ">200"]
  #}
}

  explore: users {
    persist_with: nightly
    join: order_items {
      type: left_outer
      relationship: one_to_many
      sql_on: ${users.id} = ${order_items.user_id} ;;
      }
    join: inventory_items {
      type: left_outer
      relationship: many_to_one
      sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    }


  }

datagroup: nightly{
  max_cache_age: "24 hours"
  #interval_trigger: "24 hours"
  sql_trigger: select current_date ;;
}
# This explore contains multiple views
#explore: users2  {
 # from:  users
#  join: order_items {
 #   type: left_outer
  #  relationship: one_to_many
   # sql_on: ${users2.id} = ${order_items.user_id};;
  #}

#}

# This Explore only contains a single view
# explore: products {}

















  # query: order_status_by_date{
  #   dimensions: [order_items.created_date, order_items.status]
  #   measures: [order_items.total_revenue]
  #   filters: [order_items.created_date: "last 30 days"]
  # }

  # query: orders_by_date{
  #   dimensions: [order_items.created_date]
  #   measures: [order_items.total_revenue]
  #   filters: [order_items.created_date: "last 30 days"]
  # }
