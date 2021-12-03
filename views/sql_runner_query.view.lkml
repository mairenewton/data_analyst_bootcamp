view: sql_runner_query {
  derived_table: {
    sql: SELECT
          "users"."country" AS "users.country",
          COUNT(DISTINCT users.id ) AS "users.count"
      FROM
          "public"."order_items" AS "order_items"
          LEFT JOIN "public"."users" AS "users" ON "order_items"."user_id" = "users"."id"
      GROUP BY
          1
      HAVING (COUNT(*)) > 100
      ORDER BY
          2 DESC
       ;;
  persist_for: "8 hours"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_country {
    type: string
    sql: ${TABLE}."users.country" ;;
  }

  dimension: users_count {
    type: number
    sql: ${TABLE}."users.count" ;;
  }

  set: detail {
    fields: [users_country, users_count]
  }
}
