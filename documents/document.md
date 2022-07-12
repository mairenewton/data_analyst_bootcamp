# Looker Developer Bootcamp
This branch contains all the changes needed for the Looker Developer Bootcamp organized in _22Q3_.

## First week
### Adding dimensions
- Full name (It turns out that we're using Redshift, so consider that for the SQL functions used (e.g. string concat))

```less
dimension: full_name {
  type: string
  sql: ${first_name} || ' ' || ${last_name} ;;
}
```
- Age tiered

```javascript
dimension: age_tiered {
  type:  tier
  sql: ${age} ;;
  tiers: [10, 20, 30, 40, 60, 80]
  style: integer  # interval
}
```
- User acquired through email

```css
dimension: acquired_through_email {
  type: yesno
  sql: ${traffic_source} = 'Email';;
}
```

### Adding measures
- Average age

```scss
measure: average_age {
  type:  average
  sql:  ${age} ;;
  value_format_name: decimal_2
}
```
- Count distinct cities

```perl
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

## Second week
TBC
