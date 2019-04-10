view: aggregation {
  sql_table_name: public.aggregation ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension_group: max {
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
    sql: ${TABLE}.max ;;
  }

  dimension_group: min {
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
    sql: ${TABLE}.min ;;
  }

  dimension: sum {
    type: number
    sql: ${TABLE}.sum ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: total {
    type: count
    drill_fields: []
  }
}
