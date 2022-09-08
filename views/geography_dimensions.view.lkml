
#example of centralising geography related fields
#definition and leveraging it in other views via extends e.g. in User and Events

view: geography_dimensions {
  extension: required

  dimension: country {
    group_label: "Location"
    label: "Country Name"
    drill_fields: [country, region, city]
    map_layer_name: countries
  }

  dimension: city {
    group_label: "Location"
    label: "City Name"
  }

}




# #   include: "geography_dimensions.view"
# #   include: "system_fields.view"
# #   view: users {
# #     extends: [geography_dimensions
# #       ,system_fields]
# #     sql_table_name: public.users ;;

# #     }



# # include: "system_fields.view"
# # view: order_items {
# #   extends: [system_fields]
# #   sql_table_name: public.order_items ;;
# }
# # include: "system_fields.view"
# # view: users {
# #   extends: [system_fields]
# #   sql_table_name: public.users ;;
# # }
# # include: "system_fields.view"
# # view: inventory_items {
# #   extends: [system_fields]
# #   sql_table_name: public.inventory_items ;;
# # }
