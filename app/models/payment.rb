class Payment < ActiveRecord::Base
  attr_accessible :invoice_id, :notes, :paid_full, :payment_amount, :payment_date, :payment_method, :send_payment_notification
  belongs_to :invoice

  def client_name
    self.invoice.client.organization_name rescue "credit?"
  end
end
