# dashboard related js code

# report data
jQuery ->

	# chart options
	chart_ticks = gon.chart_data["ticks"] if gon?

	chart_defaults =
		renderer: jQuery.jqplot.BarRenderer
		rendererOptions:
			fillToZero: true

	chart_series =  [
		label: "Invoices",
		label: "Paid Invoices"
	]

	chart_legend = show: true, placement: "insideGrid"

	chart_xaxis = renderer: jQuery.jqplot.CategoryAxisRenderer, ticks: chart_ticks, tickOptions:
		showGridline: false

	chart_yaxis = pad: 1.05, tickOptions:
		formatString: "$%d"


	chart_axis =
		xaxis: chart_xaxis
		yaxis: chart_yaxis

	chart_grid =
		background: '#FFFFFF'
		drawBorder: false

	chart_options =
		seriesDefaults: chart_defaults
		series: chart_series
		legend: chart_legend
		axes: chart_axis
		grid: chart_grid
		seriesColors: ['#00BDE5','#00000']

	if gon?
		invoices = gon.chart_data["invoices"]
		payments = gon.chart_data["payments"]
		chart_data = [invoices, payments]

	try
		jQuery.jqplot "dashboard-chart", chart_data, chart_options
	catch e




