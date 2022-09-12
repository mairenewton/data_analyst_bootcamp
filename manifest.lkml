project_name: "data_analyst_bootcamp"

constant: usd_1 {
  value: "$0.0"
}



constant: negative_format {
  value: "{% if value < 0 %}&#60;p style=&#92;color:red; &#92;>({{rendered_value}})</p>{% else %} {{rendered_value}} {% endif %}"
}
