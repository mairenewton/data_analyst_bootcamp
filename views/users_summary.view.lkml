view: users_summary {
  derived_table: {
    sql:
    SELECT
  users.id  AS users_id,
  COUNT(*) AS order_items_count,
  DATE(CONVERT_TIMEZONE('UTC', 'America/New_York', min(order_items.created_at) )) AS order_items_first_order_date
FROM public.order_items  AS order_items
INNER JOIN public.users  AS users ON order_items.user_id = users.id

GROUP BY 1
;;
    indexes: ["users_id"]
    # sql_trigger_value: select current_date() ;;
    datagroup_trigger: data_analyst_bootcamp_default_datagroup
    distribution_style: even
  }
  dimension: user_id {
    hidden: yes
    type: string
    sql: ${TABLE}.users_id ;;
  }
  dimension: users_lifetime_order_items_count {
    type: number
    sql: ${TABLE}.order_items_count ;;
  }
  dimension_group: order_items_first_order {
    type: time
    timeframes: [raw,date,year]
    sql: ${TABLE}.order_items_first_order_date ;;
  }
}
