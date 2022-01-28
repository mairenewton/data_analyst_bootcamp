include: "/views/order_items.view"
include: "/views/users.view"
include: "/views/pop/*.*"
explore: order_items {

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: pop_support {
    view_label: "_PoP Support - Overrides and Tools"
    relationship:one_to_one
    sql:{% if pop_support.periods_ago._in_query%}LEFT JOIN pop_support on 1=1{%endif%};;
  }


}


include: "/views/pop/pop_support.view.lkml"
view: +order_items {


  dimension_group: created {
    convert_tz: no #we need to inject the conversion before the date manipulation
    datatype: datetime
    sql:{% assign now_converted_to_date_with_timezone_sql = "${pop_support.now_converted_to_date_with_tz_sql::date}" %}{% assign now_unconverted_sql = pop_support.now_sql._sql %}{%comment%}pulling in logic from pop support template, within which we'll inject the original sql. Use $ {::date} when we want to get looker to do conversions, but _sql to extract raw sql {%endcomment%}
          {% assign selected_period_size = selected_period_size._sql | strip %}
          {%if selected_period_size == 'Day'%}{% assign pop_sql_using_now = "${pop_support.pop_sql_days_using_now}" %}{%elsif selected_period_size == 'Month'%}{% assign pop_sql_using_now = "${pop_support.pop_sql_months_using_now}" %}{%else%}{% assign pop_sql_using_now = "${pop_support.pop_sql_years_using_now}" %}{%endif%}
          {% assign my_date_converted = now_converted_to_date_with_timezone_sql | replace:now_unconverted_sql,"${EXTENDED}" %}
          {% if pop_support.periods_ago._in_query %}{{ pop_sql_using_now | replace: now_unconverted_sql, my_date_converted }}
          {%else%}{{my_date_converted}}
          {%endif%};;#wraps your original sql (i.e. ${EXTENDED}) inside custom pop logic, leveraging the parameterized selected-period-size-or-smart-default (defined below)
    }
  dimension: selected_period_size {
    hidden: yes
    sql:{%if pop_support.period_size._parameter_value != 'Default'%}{{pop_support.period_size._parameter_value}}
        {% else %}
          {% if created_date._is_selected %}Day
          {% elsif created_week._is_selected %}Week
          {% elsif created_month._is_selected %}Month
          {% elsif created_quarter._is_selected %}Quarter
          {% else %}Year
          {% endif %}
        {% endif %};;#
  }

  dimension: created_date_periods_ago_pivot {
    label: "{% if _field._in_query%}Pop Period (Created {{selected_period_size._sql}}){%else%} Pivot for Period Over Period{%endif%}"
    group_label: "Created Date"
    order_by_field: pop_support.periods_ago
    sql:{% assign period_label_sql = "${pop_support.period_label_sql}" %}{% assign selected_period_size = selected_period_size._sql | strip%}{% assign label_using_selected_period_size = period_label_sql | replace: 'REPLACE_WITH_PERIOD',selected_period_size%}{{label_using_selected_period_size}};;
  }

  parameter: timeframe {
    view_label: "_PoP Support - Overrides and Tools"
    group_label: "Multi-Period Comparison"
    label: "PoP Timeframe Size"
    description: "Utilize with Dynamic Date"
    type: unquoted
    allowed_value: {value:"Day"}
    allowed_value: {value:"Week"}
    allowed_value: {value:"Month"}
    allowed_value: {value:"Quarter"}
    allowed_value: {value:"Year"}
    allowed_value: {value:"Default" label:"Default Based on Selection"}
    default_value: "Default"
  }

  dimension: dynamic_date {
    group_label: "Created Date"
    label: "Dynamic"
    sql: {% if timeframe._parameter_value == 'Day' %} ${created_date}
          {% elsif timeframe._parameter_value == 'Week' %} ${created_week}
          {% elsif timeframe._parameter_value == 'Month' %} ${created_month}
          {% elsif timeframe._parameter_value == 'Quarter' %} ${created_quarter}
          {% else %} ${created_year} {% endif %};;
  }

  measure: earliest_created_date {
    hidden: yes
    sql: DATE(MIN(${TABLE}.created_at)) ;;
  }

  measure: latest_created_date {
    hidden: yes
    sql: DATE(MAX(${TABLE}.created_at)) ;;
  }

  measure: dates_in_period {
    view_label: "_PoP Support - Overrides and Tools"
    group_label: "Multi-Period Comparison"
    can_filter: no
    sql: CONCAT(${earliest_created_date},' until (before) ',${latest_created_date}) ;;
  }

}
