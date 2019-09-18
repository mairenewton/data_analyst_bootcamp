view: colorado_regions {
  derived_table: {
    sql:
        -- some quick dummy data to show
        SELECT
        'West Colorado' AS co_region,
        2000594 AS co_region_population
        UNION ALL
        SELECT
        'East Colorado' AS co_region,
        3920872 AS co_region_population
        ;;
  }
  dimension: co_regions {
    sql: ${TABLE}.co_region;;
    label: "Colorado Regions"
    map_layer_name: colorado_region
  }
  measure: ri_region_population {
    label: "Colorado Population by Region"
    type: average
    sql: ${TABLE}.co_region_population ;;
  }
}

view: better_colorado_regions {
  derived_table: {
    sql:
      SELECT
        'Plains' as region,
        100000 as population
      UNION ALL
      SELECT
        'Rockies' as region,
        250000 as population
      UNION ALL
      SELECT
        'West Colorado' as region,
        150000 as population
      UNION  ALL
      SELECT
        'Front Range' as region,
        1000000 as population
        ;;
  }
  dimension: co_regions {
    sql: ${TABLE}.region;;
    label: "Colorado Regions"
    map_layer_name: better_colorado_region
  }
  measure: ri_region_population {
    label: "Colorado Population by Region"
    type: average
    sql: ${TABLE}.population ;;
  }
}
