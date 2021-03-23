view: foo {
  sql_table_name: public.foo ;;

  dimension: i {
    type: number
    sql: ${TABLE}.i ;;
  }
##added a comment
  measure: count {
    type: count
    drill_fields: []
  }
}

##comment test
