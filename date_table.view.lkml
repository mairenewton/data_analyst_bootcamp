view: forecasted_poc{
  derived_table: {
    sql: SELECT
      '2016-01-01'     as "date",
      0.057      as "Northern California - % Annual Price Change",
      0.052      as "Central California - % Annual Price Change",
      0.051      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2016-06-01'     as "date",
      0.059      as "Northern California - % Annual Price Change",
      0.0594      as "Central California - % Annual Price Change",
      0.0592      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2017-01-01'     as "date",
      0.05     as "Northern California - % Annual Price Change",
      0.0567      as "Central California - % Annual Price Change",
      0.0564      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2017-06-01'     as "date",
      0.055   as "Northern California - % Annual Price Change",
      0.053      as "Central California - % Annual Price Change",
      0.0521      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2018-01-01'     as "date",
      0.052  as "Northern California - % Annual Price Change",
      0.051     as "Central California - % Annual Price Change",
      0.05      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2018-06-01'     as "date",
      0.058  as "Northern California - % Annual Price Change",
      0.056     as "Central California - % Annual Price Change",
      0.0542     as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2019-01-01'    as "date",
      0.059 as "Northern California - % Annual Price Change",
      0.053    as "Central California - % Annual Price Change",
      0.0556     as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2019-06-01'     as "date",
      0.061 as "Northern California - % Annual Price Change",
      0.065    as "Central California - % Annual Price Change",
      0.0632      as "Southern Calfornia - % Annual Price Change",
      0 as "Northern California - % Annual Forecasted Price Change",
      0 as "Central California - % Annual Forecasted Price Change",
      0 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2020-01-01'     as "date",
      0 as "Northern California - % Annual Price Change",
      0    as "Central California - % Annual Price Change",
      0       as "Southern Calfornia - % Annual Price Change",
      0.067  as "Northern California - % Annual Forecasted Price Change",
      0.063  as "Central California - % Annual Forecasted Price Change",
      0.062  as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2020-06-01'     as "date",
      0 as "Northern California - % Annual Price Change",
      0    as "Central California - % Annual Price Change",
      0       as "Southern Calfornia - % Annual Price Change",
      0.072 as "Northern California - % Annual Forecasted Price Change",
      0.071 as "Central California - % Annual Forecasted Price Change",
      0.065 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2021-01-01'     as "date",
      0 as "Northern California - % Annual Price Change",
      0    as "Central California - % Annual Price Change",
      0   as "Southern Calfornia - % Annual Price Change",
      0.072  as "Northern California - % Annual Forecasted Price Change",
      0.0712 as "Central California - % Annual Forecasted Price Change",
      0.07     as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2021-06-01'     as "date",
      0 as "Northern California - % Annual Price Change",
      0     as "Central California - % Annual Price Change",
      0      as "Southern Calfornia - % Annual Price Change",
      0.069  as "Northern California - % Annual Forecasted Price Change",
      0.0696 as "Central California - % Annual Forecasted Price Change",
      0.0692 as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2022-01-01'     as "date",
      0 as "Northern California - % Annual Price Change",
      0      as "Central California - % Annual Price Change",
      0      as "Southern Calfornia - % Annual Price Change",
      0.067  as "Northern California - % Annual Forecasted Price Change",
      0.0674 as "Central California - % Annual Forecasted Price Change",
      0.067  as "Southern Calfornia - % Annual Forecasted Price Change"
      UNION ALL
      SELECT
      '2022-06-01'    as "date",
      0 as "Northern California - % Annual Price Change",
      0       as "Central California - % Annual Price Change",
      0      as "Southern Calfornia - % Annual Price Change",
      0.074  as "Northern California - % Annual Forecasted Price Change",
      0.0729 as "Central California - % Annual Forecasted Price Change",
      0.072  as "Southern Calfornia - % Annual Forecasted Price Change"
 ;;
  }


  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: northern_california___annual_price_change {
    type: number
    label: "northern california - % annual price change"
    sql:
    CASE WHEN ${TABLE}."northern california - % annual price change" = 0 THEN NULL ELSE ${TABLE}."northern california - % annual price change"  END
     ;;
  }

  measure: norcal_price_change {
    value_format_name: percent_2
    type: sum
    sql: ${northern_california___annual_price_change} ;;
  }

  dimension: central_california___annual_price_change {
    type: number
    label: "central california - % annual price change"
    sql:
    CASE WHEN ${TABLE}."Central California - % Annual Price Change" = 0 THEN NULL ELSE ${TABLE}."Central California - % Annual Price Change"  END ;;
  }

  measure: central_price_change {
    value_format_name: percent_2
    type: sum
    sql: ${central_california___annual_price_change} ;;
  }

  dimension: southern_calfornia___annual_price_change {
    type: number
    label: "southern calfornia - % annual price change"
    sql:

    CASE WHEN ${TABLE}."southern calfornia - % annual price change" = 0 THEN NULL ELSE ${TABLE}."southern calfornia - % annual price change"  END ;;
  }

  measure: socal_price_change {
    value_format_name: percent_2
    type: sum
    sql: ${southern_calfornia___annual_price_change} ;;
  }

  dimension: northern_california___annual_forecasted_price_change {
    type: number
    label: "northern california - % annual forecasted price change"
    sql:

    CASE WHEN ${TABLE}."northern california - % annual forecasted price change" = 0 THEN NULL ELSE ${TABLE}."northern california - % annual forecasted price change"  END ;;
  }

  measure: norcal_forecasted_change {
    type: sum
    sql: ${northern_california___annual_forecasted_price_change} ;;
  }

  dimension: central_california___annual_forecasted_price_change {
    type: number
    label: "central california - % annual forecasted price change"
    sql:

    CASE WHEN ${TABLE}."central california - % annual forecasted price change" = 0 THEN NULL ELSE ${TABLE}."central california - % annual forecasted price change"  END ;;
  }

  measure: central_forecasted_change {
    type: sum
    sql: ${central_california___annual_forecasted_price_change} ;;
  }

  dimension: southern_calfornia___annual_forecasted_price_change {
    type: number
    label: "southern calfornia - % annual forecasted price change"
    sql:

    CASE WHEN ${TABLE}."southern calfornia - % annual forecasted price change" = 0 THEN NULL ELSE ${TABLE}."southern calfornia - % annual forecasted price change" END ;;
  }

  measure: socal_forecasted_change {
    type: sum
    sql: ${southern_calfornia___annual_forecasted_price_change} ;;
  }


}
