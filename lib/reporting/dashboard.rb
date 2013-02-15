module Reporting
  module Dashboard

    # get the recent activity - 10 most recent items
    def self.get_recent_activity
      # columns returned: activity type, client, amount, activity date
      # fetch last 10 invoices and payments
      invoices = Invoice.select("id, client_id, invoice_total, created_at").order("created_at DESC").limit(5)
      payments = Payment.select("payments.id, clients.organization_name, payments.payment_amount, payments.created_at").includes(:invoice => :client).joins(:invoice => :client).order("payments.created_at DESC").limit((10 - invoices.length))

      # merge invoices and payments in activity array
      recent_activity = []
      invoices.each { |inv| recent_activity << {:activity_type => "invoice", :activity_action => "sent to", :client => inv.client.organization_name, :amount => inv.invoice_total, :activity_date => inv.created_at, :activity_path => "/invoices/#{inv.id}/edit"} }
      payments.each { |pay| recent_activity << {:activity_type => "payment", :activity_action => "received from", :client => pay.invoice.client.organization_name, :amount => pay.payment_amount, :activity_date => pay.created_at, :activity_path => "/payments/#{pay.id}/edit"} }

      # sort them by created_at in descending order
      recent_activity.sort { |a, b| b[:created_at] <=> a[:created_at] }
    end

    # get chart data
    def self.get_chart_data
      # month, invoices amount, payments amount
      number_of_months = 6
      chart_months = {}
      start_date = (number_of_months * -1).months.from_now.to_date.at_beginning_of_month
      end_date = Date.today.at_end_of_month
      # build a hash of months with nil amounts
      number_of_months.times { |i| chart_months[(start_date + (i+1).month).month] = nil }

      # invoices amount group by month for last *number_of_months* months
      invoices = Invoice.group("month(invoice_date)").where(:invoice_date => start_date..end_date).sum("invoice_total")
      # TODO: credit amount handling
      payments = Payment.group("month(payment_date)").where(:payment_date => start_date..end_date).sum("payment_amount")

      chart_data = {}
      chart_data[:invoices] = chart_months.merge(invoices).map { |month, amount| amount }
      chart_data[:payments] = chart_months.merge(payments).map { |month, amount| amount }
      chart_data[:ticks] = chart_months.map { |month, amount| Date::ABBR_MONTHNAMES[month] }
      Rails.logger.debug chart_data
      chart_data

    end

    # get outstanding invoices
    def self.get_outstanding_invoices
      Payment.total_payments_amount - Invoice.total_invoices_amount
    end
  end
end