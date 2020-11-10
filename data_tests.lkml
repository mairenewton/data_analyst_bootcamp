##--Data Tests--##

##Tips:
# (1) An easy way to get the explore_source LookML is to use an existing Explore
#     to create your query, then select Get LookML from the Explore’s gear menu and
#     click the Derived Table tab to get the LookML for the query.

##What to know about Data Tests:
# (1) 5000 row limit
# (2) If your project settings are configured to require data tests to pass before deploying
#     to production, the IDE will present the Run Tests button after you commit changes to the
#     project.LookML developers must run the data tests before deploying changes to production.


###Examples:

test: status_is_not_null {
  explore_source: order_items {
    column: status {}
    sorts: [order_items.status: desc]
    limit: 1
  }
  assert: status_is_not_null {
    expression: NOT is_null(${order_items.status}) ;;
  }
}

#This next data test checks to make sure that the 2017 revenue value is always $626,000.

test: historic_revenue_is_accurate {
  explore_source: order_items {
    column: total_sales {
      field: order_items.total_sales
    }
    filters: [order_items.created_date: "2017"]
  }
  assert: revenue_is_expected_value {
    expression: ${order_items.total_sales} = 626000 ;;
  }
}
