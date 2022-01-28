explore: users_and_orders {}
view: users_and_orders {
  derived_table: {
    sql:
    SELECT order_id as id
    FROM ${order_items.SQL_TABLE_NAME}
    UNION
    SELECT user_id as id
    FROM ${user_facts.SQL_TABLE_NAME}
    ;;
  }

  dimension: id {
    type: number
  }

}
