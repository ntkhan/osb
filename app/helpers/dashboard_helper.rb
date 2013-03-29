module DashboardHelper
  def invoices_by_period period
    Reporting::Dashboard.get_invoices_by_period period
  end
end
