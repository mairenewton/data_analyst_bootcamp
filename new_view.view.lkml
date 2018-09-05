view:  derived_table {
  derived_table: {
    sql: SELECT
         order_items.user_id as user_id
        ,COUNT(distinct order_items.order_id) as lifetime_order_count
        ,SUM(order_items.sale_price) as lifetime_revenue
        ,MIN(order_items.created_at) as first_order_date
        ,MAX(order_items.created_at) as latest_order_date
    FROM order_items
    GROUP BY user_id
    ;;
  }
}
