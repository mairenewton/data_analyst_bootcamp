connection: "events_ecommerce"

# include all the views
include: "*.view"

## colorado stuff
map_layer: colorado_region {
  file: "colorado.topojson"
  property_key: "REGION"
}

map_layer: better_colorado_region {
  file: "better_colorado.topojson"
  property_key: "Region"
}

explore: colorado_regions {}
explore: better_colorado_regions {}



explore: forecasted_poc {}















# This explore contains multiple views
explore: order_items {
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
}


#explore: users {
#  description: "**NOTE**: data is only from the last 12 months"
#  label: "Users (Data from last 12 months)"
#  sql_always_where:
#  {% if selected_timeframe._parameter_value == "This Month" %}
#  ${created_date} = this_month
#  {% if selected_timeframe._parameter_value == "This Year" %}
#  ${created_year} = this year
#  ...
#  ...
#  {% else %}
#  last 12 months..
#
#
#  ${created_date} > current_date ;;
#  #conditionally_filter: {
#  #  filters: {
#  #    field: state
#  #    value: "California"
#  #  }
#  #  unless: [country, gender]
#  #}
#
#
#
#
#
#
#
#
#
#}
#
