# Code Snippets

Put your documentation here! Your text is rendered with [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown).

Click the "Edit Source" button above to make changes.

# Dimensions

```
dimension: full_name {
label: "Customer Name"
type: string
sql: ${first_name}||' '||${last_name} ;;
}

dimension: days_since_signup {
type: number
sql: CURRENT_DATE - ${created_date} ;;

}
dimension: is_new_customer {
  type: yesno
  description: "Customer signed up less than 30 days ago"
  sql: ${days_since_signup}<30 ;;
}

dimension: days_since_signup_tier {
  type: tier
  sql: ${days_since_signup} ;;
  tiers: [0,100,200,300,400,500,600]
  style: integer
}
```

# Measures

```
measure: total_sales {
type: sum
sql: ${sale_price} ;;
}

measure: count_distinct_orders {
type: count_distinct

measure: average_sales {
type: average
sql: ${sale_price} ;;
}

measure: total_sales_new_users {
  type: sum
  sql: ${sale_price} ;;
  filters: {
    field: users.is_new_customer
    value: "Yes"
  }
}

measure: percent_sales_new_users {
  type: number
  sql: ${total_sales_new_users}/${total_sales} ;;
  value_format_name: percent_2
}

sql: ${order_id} ;;
}
```

# Sets

```
set: user_basic_info {
fields: [id,first_name,last_name]
}

drill_fields: [user_basic_info*]
```
