# dashboard related js code

# report data
jQuery ->
  # chart data
  d1 = [3500, 3200, 3900, 2500, 2000]
  d2 = [2800, 3000, 4900, 1500, 1000]
  chart_data = [d1, d2]

  # chart options
  chart_ticks = ["Jan", "Feb", "Mar", "Apr", "May"]
  chart_defaults =
    renderer: jQuery.jqplot.BarRenderer
    rendererOptions:
      fillToZero: true
  chart_series =  [
    label: "Invoices"
  ,
    label: "Paid Invoices"
  ]
  chart_legend = show: true, plcement: "outsideGrid"
  chart_xaxis = renderer: jQuery.jqplot.CategoryAxisRenderer, ticks: chart_ticks
  chart_yaxis = pad: 1.05, tickOptions:
    formatString: "$%d"
  chart_axis = xaxis: chart_xaxis, yaxis: chart_yaxis

  chart_options =
    seriesDefaults: chart_defaults
    series: chart_series
    legend: chart_legend
    axes: chart_axis

  jQuery.jqplot "dashboard-chart", chart_data, chart_options

