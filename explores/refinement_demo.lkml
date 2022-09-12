#create pre-defined analysis for an Explore (Quick Start section)
#this is helpful to beginner Looker users, since you can specify elements like the dimensions, measures, filters, and pivots that may be the most relevant and insightful.

include: "/explores/order_items_explore.lkml"
include: "/views/order_items.view"
include: "/explores/extend_explore.lkml"


explore: +order_items {
  query: order_count_by_month_in_2021 {
    description: "Number of orders placed by month in 2021"
    dimensions: [order_items.created_month]
    measures: [order_items.count_orders]
    filters: [order_items.created_date: "2021"]
  }
}


explore: +order_items {

  query: user_count_by_month_in_2021 {
    description: "No. of orders by month by department (men/women) in 2021"
    dimensions: [order_items.created_month]
    measures: [order_items.count_users]
    filters: [order_items.created_date: "2021"]
  }
}


explore: +order_items {

  query: revenue_order_status_by_date{
    description: "Total revenue by order status by date in the last 30 days"
    dimensions: [order_items.created_date]
    measures: [order_items.total_revenue]
    pivots: [order_items.status]
    filters: [order_items.created_date: "last 30 days"]
  }
}
