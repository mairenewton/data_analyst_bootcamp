view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: Shiping_Days {
    type:  duration_day
    sql_end:${delivered_date};;
    sql_start:${shipped_date} ;;
  }
  #This is better as intervls cn be added , but it doesn't work in RedShift
  #dimension: Shiping_time {
   # type:  duration
    #intervals: [day,hours]
    #sql_end:${delivered_date};;
    #sql_start:${shipped_date} ;;
  #}



parameter: date_granularity_selector {
  type:  unquoted
  default_value: "created_month"
  allowed_value: {
    value: "created_date"
    label: "Created date"
  }
  allowed_value: {
    value: "created_week"
    label: "Created week"
  }
  allowed_value: {
    value: "created_month"
    label: "Created Month"
  }
#default_value: "created_month"
}

dimension: dynamic_date{
  label_from_parameter: date_granularity_selector
  type: string
  sql:
  {%if date_granularity_selector._parameter_value =='created_date' %}
    ${created_date}
  {%elsif date_granularity_selector._parameter_value =='created_week' %}
  ${created_week}
  {%else %}
  ${created_month}
  {%endif%}

    ;;


}


  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_week,
      date,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    #hidden: yes
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: profit {
    type: number
    sql: ${sale_price} - ${inventory_items.cost} ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    label: "Order Status"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: sale_price {
    type: number
    sql: ROUND(${TABLE}.sale_price,2) ;;
    #hidden: yes
  }

  measure: count_distinct_nb_orders {
    type:  count_distinct
    sql: ${order_id} ;;
  }
  measure: Total_sales {
    type: sum
    value_format: "$#.00;($#.00)"

    sql: ${sale_price} ;;
  }
  measure: Average_Sales_price {
    type:  average
    sql: ${sale_price} ;;
    value_format: "$#.00;($#.00)"
    #value_format_name: usd # GGLE predefined formats
  }
  measure: Total_sales_Through_Email {
    type: sum
    sql: ${sale_price} ;;
    filters: [users.Email_Yes_No: "yes"]
  }
  measure: Total_sales_Through_Email_Pros {
    type: number
    sql: ${Total_sales_Through_Email}/NULLIF(${Total_sales},0) ;;
    value_format_name: percent_1
  }
  measure: nb_users {
    type: number
    sql: ${user_id} ;;
  }
  measure: Avg_Sales_per_user{
    type: number
    sql: ${Total_sales}/NULLIF(${nb_users},0) ;;
    value_format_name: percent_1
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_item_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name,
      sale_price
    ]
 }
  set: Item_Details {
    fields: [order_id, status, created_date,sale_price,products.brand,products.name]
  }

}
