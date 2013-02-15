class DashboardController < ApplicationController
  def index
    @recent_activity = Reporting::Dashboard.get_recent_activity
    gon.chart_data = Reporting::Dashboard.get_chart_data
  end
end
