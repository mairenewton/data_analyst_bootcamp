view: system_fields {
  extension: required

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, month_num, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
}
