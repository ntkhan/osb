module Reporting
  module Dashboard

    # get the recent activity - 10 most recent items
    def self.get_recent_activity
      # columns returned: activity type, client, amount, activity date
      # fetch last 10 invoices and payments
      invoices = Invoice.select("id, client_id, invoice_total, created_at").order("created_at DESC").limit(5)
      payments = Payment.select("payments.id, clients.organization_name, payments.payment_amount, payments.created_at").includes(:invoice => :client).joins(:invoice => :client).order("payments.created_at DESC").limit(10 - invoices.length)

      # merge invoices and payments in activity array
      recent_activity = []
      invoices.each{|inv| recent_activity << {:activity_type => "invoice", :activity_action => "sent to", :client => inv.client.organization_name, :amount => inv.invoice_total, :activity_date => inv.created_at, :activity_path => "/invoices/#{inv.id}/edit"}}
      payments.each{|pay| recent_activity << {:activity_type => "payment", :activity_action => "received from", :client => pay.invoice.client.organization_name, :amount => pay.payment_amount, :activity_date => pay.created_at, :activity_path => "/payments/#{pay.id}/edit" }}

      # sort them by created_at in descending order
      recent_activity.sort{|a, b| b[:created_at] <=> a[:created_at]}
    end
  end
end