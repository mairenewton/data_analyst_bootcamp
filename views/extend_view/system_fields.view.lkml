view: system_fields {
  extension: required

  dimension: id {
    #hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.created_at ;;
  }

  dimension: welcome_message {
    type: string
    sql: 1 ;;
    html: Welcome {{ _user_attributes['first_name']}} {{ _user_attributes['last_name']}}! ;;
  }

  parameter: date_granularity_selector {
    type: unquoted
    default_value: "created_month"
    allowed_value: {
      value: "created_date"
      label: "Created Date"
    }
    allowed_value: {
      value: "created_week"
      label: "Created Week"
    }
    allowed_value: {
      value: "created_month"
      label: "Created Month"
    }
  }


dimension: dynamic_timeframe {
    label_from_parameter: date_granularity_selector
    type: string
    sql:
    {% if date_granularity_selector._parameter_value == 'created_date' %}
    ${created_date}
    {% elsif date_granularity_selector._parameter_value == 'created_week' %}
    ${created_week}
    {% else %}
    ${created_month}
    {% endif %} ;;
    }






}
