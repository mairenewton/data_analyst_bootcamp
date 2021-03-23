connection: "events_ecommerce"

# include all the views
include: "/views/*.view"



datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default {
  sql_trigger: select date(now());;
}

datagroup: order_items {
  sql_trigger: select max(order_items.created_at) from public.order_items ;;
  max_cache_age: "4 hours"
}


# persist_with: data_analyst_bootcamp_default_datagroup
persist_with: default
#comment

# explore: inventory_items {}

# This explore contains multiple views
explore: order_items {
  access_filter: {
    field: products.brand
    user_attribute: brand
  }

  access_filter: {
    field: users.state
    user_attribute: state
  }


  #FROM
  persist_with: order_items
  group_label: "## - Data Analyst Bootcamp"
  # conditionally_filter: {

  #   filters: [order_items.created_date: "after 2 years ago"]
  #   unless: [users.id]
  # }


  # sql_always_where: ${status} <> 'Returned' ;;
  # sql_always_having: ${total_sale_price} > 200 ;;

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one #STEP 2 - ENSURING THERE IS NO "FANOUT"
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: brand_order_facts_ndt {
    sql_on: ${brand_order_facts_ndt.product_brand}=${products.brand} ;;
    type: left_outer
    relationship: many_to_one
  }

}

explore: users {
  description: "All Users Information"

  group_label: "## - Data Analyst Bootcamp"

  # fields: [ALL_FIELDS*, -order_items.profit]

  # conditionally_filter: {
  #   filters: [ order_items.created_date: "last 2 year"]
  #   unless: [users.id]
  # }


  # join: order_items {
  #   # fields: [order_items.order_id, order_items.sale_price, order_items.total_sale_price]
  #   type: left_outer
  #   sql_on: ${users.id} = ${order_items.user_id} ;;
  #   relationship: one_to_many
  # }

  join: user_facts {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }
}

# explore: products {}

# explore: user_facts {}

explore: total_cost_inventory_items_by_sku {
  join: total_cost_goods_sold_by_sku {
    sql_on: ${total_cost_goods_sold_by_sku.product_sku}=${total_cost_inventory_items_by_sku.inventory_items_product_sku} ;;
    type: left_outer
    relationship: one_to_one
  }
}
