# Looker Developer Bootcamp
This branch contains all the changes needed for the Looker Developer Bootcamp organized in _22Q3_.

## First week
### Adding dimensions
- Full name (It turns out that we're using Redshift, so consider that for the SQL functions used (e.g. string concat))

```coffee
dimension: full_name {
  type: string
  sql: ${first_name} || ' ' || ${last_name} ;;
}
```
- Age tiered

```coffee
dimension: age_tiered {
  type:  tier
  sql: ${age} ;;
  tiers: [10, 20, 30, 40, 60, 80]
  style: integer  # interval
}
```
- User acquired through email

```coffee
dimension: acquired_through_email {
  type: yesno
  sql: ${traffic_source} = 'Email';;
}
```

### Adding measures
- Average age

```coffee
measure: average_age {
  type:  average
  sql:  ${age} ;;
  value_format_name: decimal_2
}
```
- Count distinct cities

```coffee
measure: cities {
  type: count_distinct
  sql:  ${city} ;;
}
```
- Percentage of users acquired through email

```coffee
measure: count_users_acquired_through_email {
  type:  count
  filters: [
    acquired_through_email: "yes"
  ]
}

measure: percent_users_acquired_through_email {
  type:  number
  sql:  1.0 * ${count_users_acquired_through_email} / ${count} ;;
  value_format_name: percent_2
}
```

### Additional remarks
You can hide dimensions/measures, add labels, descriptions, group them

### Exercises
1. A dimension that would show the precise location of a user on the map

```coffee
dimension: location {
  type:  location
  sql_longitude: ${longitude} ;;
  sql_latitude: ${latitude} ;;
}
```

2. A dimension that would calculate how many days ago (bonus points for weeks, months, quarters and years) each user was created

```coffee
dimension_group: tenure {
  type:  duration
  intervals: [
    day,
    week,
    month,
    quarter,
    year
  ]
  sql_start:  ${created_date} ;;
  sql_end:  CURRENT_DATE ;;
}
```

3. Considering all users, create a measure that would calculate how many years ago on average the users have signed up to our ecommerce platform.

```coffee
measure: average_tenure {
  type: average
  sql:  ${years_tenure} ;;
  value_format_name: decimal_2
}
```

4. Create a measure that would calculate the number of new users. A new user is a user who has been created in the past 30 days

```coffee
dimension: is_new {
  type:  yesno
  sql:  ${days_tenure} <= 30 ;;
}

measure: count_new_users {
  type: count
  filters: [
    is_new: "yes"
  ]
}
```

## Second week
TBC
