class DashboardController < ApplicationController
  def index
    @recent_activity = Reporting::Dashboard.get_recent_activity
    gon.chart_data = Reporting::Dashboard.get_chart_data
    @aged_invoices = Reporting::Dashboard.get_aging_data
    @outstanding_invoices = (@aged_invoices.attributes["zero_to_thirty"] || 0) +
        (@aged_invoices.attributes["thirty_one_to_sixty"] || 0) +
        (@aged_invoices.attributes["sixty_one_to_ninety"] || 0) +
        (@aged_invoices.attributes["ninety_one_and_above"] || 0)
  end
end

