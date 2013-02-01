module Reporting
  class Reports
    # @criteria = {:from, :to, :client, :payment_type}
    # @return [PaymentsCollected]
    def self.payments_collected(criteria={})
      # Report columns: Invoice# 	Client Name 	Type 	Note 	Date 	Amount
      Payment.select(
          "payments.id as payment_id,
        invoices.id as invoice_id,
        clients.organization_name as client_name,
        payments.payment_type,
        payments.payment_method,
        payments.notes,
        payments.payment_amount,
        payments.created_at").includes(:invoice => :client).joins(:invoice => :client)
    end
  end
end