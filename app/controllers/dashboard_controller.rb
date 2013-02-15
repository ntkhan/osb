class DashboardController < ApplicationController
  def index
    @recent_activity = Reporting::Dashboard.get_recent_activity
    gon.chart_data = Reporting::Dashboard.get_chart_data
    @outstanding_invoices = Reporting::Dashboard.get_outstanding_invoices
  end
end
