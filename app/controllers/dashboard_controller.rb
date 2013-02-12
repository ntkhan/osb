class DashboardController < ApplicationController
  def index
    @recent_activity = Reporting::Dashboard.get_recent_activity
  end
end
