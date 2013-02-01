module Reporting
  class Reports
    # @criteria = {:from, :to, :client, :payment_type}
    # @return [PaymentsCollected]
    def self.payments_collected(criteria={})
      # setting defaults if any of the criteria option is missing
      criteria[:from_date]      ||= 1.month.ago
      criteria[:to_date]        ||= Date.today
      criteria[:client_id]      ||= 0
      criteria[:payment_method] ||= 0

      # Report columns: Invoice# 	Client Name 	Type 	Note 	Date 	Amount
      payments = Payment.select(
          "payments.id as payment_id,
        invoices.invoice_number,
        invoices.id as invoice_id,
        clients.organization_name as client_name,
        payments.payment_type,
        payments.payment_method,
        payments.notes,
        payments.payment_amount,
        payments.created_at")
      .includes(:invoice => :client)
      .joins(:invoice => :client)
      .where(:created_at => criteria[:from_date]..criteria[:to_date])

      payments.where(["clients.id = ?", criteria[:client_id]])                    unless criteria[:client_id] == 0
      payments.where(["payments.payment_method = ?", criteria[:payment_method]])  unless criteria[:payment_method] == 0

      payments

    end
  end
end