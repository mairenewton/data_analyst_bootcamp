view: order_items {
  sql_table_name: public.order_items ;;

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
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
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
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

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
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
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: wtd_only {
    group_label: "To-Date Filters"
    label: "WTD"
    type: yesno
    sql:  (EXTRACT(DOW FROM ${created_raw}) < EXTRACT(DOW FROM GETDATE())
                OR
            (EXTRACT(DOW FROM ${created_raw}) = EXTRACT(DOW FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE()))
                OR
            (EXTRACT(DOW FROM ${created_raw}) = EXTRACT(DOW FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM GETDATE()) AND
            EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM GETDATE())))  ;;
  }

  dimension: mtd_only {
    group_label: "To-Date Filters"
    label: "MTD"
    type: yesno
    sql:  (EXTRACT(DAY FROM ${created_raw}) < EXTRACT(DAY FROM GETDATE())
                OR
            (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE()))
                OR
            (EXTRACT(DAY FROM ${created_raw}) = EXTRACT(DAY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM GETDATE()) AND
            EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM GETDATE())))  ;;
  }

  dimension: ytd_only {
    group_label: "To-Date Filters"
    label: "YTD"
    type: yesno
    sql:  (EXTRACT(DOY FROM ${created_raw}) < EXTRACT(DOY FROM GETDATE())
                OR
            (EXTRACT(DOY FROM ${created_raw}) = EXTRACT(DOY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) < EXTRACT(HOUR FROM GETDATE()))
                OR
            (EXTRACT(DOY FROM ${created_raw}) = EXTRACT(DOY FROM GETDATE()) AND
            EXTRACT(HOUR FROM ${created_raw}) <= EXTRACT(HOUR FROM GETDATE()) AND
            EXTRACT(MINUTE FROM ${created_raw}) < EXTRACT(MINUTE FROM GETDATE())))  ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  measure: total_sales {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: gbp
    drill_fields: [created_date,detail*]
  }

  measure: ly_sales{
    type: sum
    sql: ${sale_price} ;;
    filters: [created_year: "last year"]
    value_format_name: gbp
  }

  measure: ty_sales{
    type: sum
    sql: ${sale_price} ;;
    filters: [created_year: "this year"]
    value_format_name: gbp
    drill_fields: [detail*,variation]
  }

  measure: variation {
    type: number
    sql: ${ty_sales}/${ly_sales} ;;
    value_format_name: percent_0
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      order_item_id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
