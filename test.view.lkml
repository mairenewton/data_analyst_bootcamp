view: test {
  derived_table: {
    sql: select FIRST_NAME,LAST_NAME FROM USERS
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  set: detail {
    fields: [first_name, last_name]
  }
}
