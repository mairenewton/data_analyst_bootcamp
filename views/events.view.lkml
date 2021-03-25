view: events {
  sql_table_name: public.events ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
  }
}

view: events_by_date {
  derived_table: {
    datagroup_trigger: default
    distribution_style: all
    explore_source: events {
      column: created_date {}
      column: event_type {}
      column: count {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: event_type {}
  dimension: count {
    type: number
  }
}

view: events_by_month {
  derived_table: {
    datagroup_trigger: default # will persist each version of the table
    distribution_style: all
    explore_source: events {
      column: created_date {field: events.created_month}
      column: event_type {}
      column: count {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: event_type {}
  dimension: count {
    type: number
  }
}

view: events_by_year {
  derived_table: {
    datagroup_trigger: default
    distribution_style: all
    explore_source: events {
      column: created_date {field: events.created_year}
      column: event_type {}
      column: count {}
    }
  }
  dimension: created_date {
    type: date
  }
  dimension: event_type {}
  dimension: count {
    type: number
  }
}

view: events_rollup {
  derived_table: {
    sql:
    SELECT *
    FROM
    --Toggle between teh different tables
    {% if created_date._in_query %} ${events_by_date.SQL_TABLE_NAME}
    {% elsif created_month._in_query %} ${events_by_date.SQL_TABLE_NAME}
    {% else %} ${events_by_date.SQL_TABLE_NAME}
    {% endif %}
    ;;
  }
  dimension_group: created {
    type: time
    datatype: date
    timeframes: [raw,date,month,year]
    sql: ${TABLE}.created_date ;;
  }


  dimension: event_type {}
  dimension: count {
    type: number
  }
}
