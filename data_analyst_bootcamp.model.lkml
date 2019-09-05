connection: "events_ecommerce"

# include all the views
include: "*.view"

access_grant: finance {
  allowed_values: ["Finance","CEO"]
  user_attribute: department
}

datagroup: data_analyst_bootcamp_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: order_items {
  sql_trigger: select count(*) from order_items ;;
}

persist_with: data_analyst_bootcamp_default_datagroup

# This explore contains multiple views
explore: order_items {
#   access_filter: {
#     field: order_items.company_id
#     user_attribute: company_id
#   }
# extension: required
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: user_order_fact {
    view_label: "Users"
    type: inner
    sql_on: ${order_items.user_id} = ${user_order_fact.user_id} ;;
    relationship: many_to_one
  }

  join: user_order_fact_ndt {
    type: inner
    sql_on: ${order_items.user_id} = ${user_order_fact_ndt.user_id} ;;
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
}

# explore: order_items_new {
#   extends: [order_items]
# }

explore: products {}


# explore: users {
#   join: user_order_fact {
#     type: left_outer
#     sql_on: ${users.id} = ${user_order_fact.user_id} ;;
#     relationship: many_to_one
#   }
#   join: order_items {
#     type: left_outer
#     sql_on: ${users.id} = ${order_items.user_id} ;;
#     relationship: one_to_many
#   }
#   join: user_order_fact_ndt {
#     type: inner
#     sql_on: ${order_items.user_id} = ${user_order_fact_ndt.user_id} ;;
#     relationship: many_to_one
#   }
#   join: user_order_fact {
#     view_label: "Users"
#     type: inner
#     sql_on: ${order_items.user_id} = ${user_order_fact.user_id} ;;
#     relationship: many_to_one
#   }
# }
