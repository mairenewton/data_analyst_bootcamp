include: "/models/*"
explore: +order_items {
  query: order_count_by_month {
    description: "Number of orders placed by month in 2019"
    dimensions: [order_items.created_month]
    measures: [order_items.count]
    filters: [order_items.created_date: "2019"]
  }
}
