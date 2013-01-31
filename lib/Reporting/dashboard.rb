module Reporting
  module Dashboard
    def self.get_recent_activity
      # fetch invoices and payments created in last 24 hours
      invoices = Invoice.select("invoice.id, client_id, invoice_total, created_at").where(["created_at <= ?", 24.hours.from_now])
      Payment.select("payments.id, clients.organization_name, payments.payment_amount, payments.created_at").joins(:invoice => :client).where(["payments.created_at <= ?", 24.hours.from_now])

      # merge invoices and payments in activity array
      activity = []
      invoices.each{|inv| activity << {:activity_type => "invoice", :client => inv.client.organization_name, :amount => inv.invoice_total, :activity_date => inv.created_at }}
      payments.each{|pay| activity << {:activity_type => "payment", :client => pay.invoice.client.organization_name, :amount => pay.payment_amount, :activity_date => pay.created_at }}

      # sort them by created_at in descending order
      activity.sort{|a, b| b[:created_at] <=> a[:created_at]}
    end
  end
end