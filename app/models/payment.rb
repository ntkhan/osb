class Payment < ActiveRecord::Base
  attr_accessible :invoice_id, :notes, :paid_full, :payment_amount, :payment_date, :payment_method, :send_payment_notification
  belongs_to :invoice

  def client_name
    self.invoice.client.organization_name rescue "credit?"
  end
  def self.update_invoice_status payments
    payments.each do |py|
      diff = py.payment_amount-py.invoice.invoice_total
      if diff > 0
        status = 'paid'
        self.add_credit_payment py.invoice.id, diff
        py.payment_amount = py.invoice.invoice_total
      elsif diff < 0
        status = 'partial'
      else
        status = 'paid'
      end
      py.invoice.status = status
      py.invoice.save
      py.save
    end
  end

  def self.add_credit_payment inv_id, amount
    credit_pay = Payment.new
    credit_pay.payment_type = 'credit'
    credit_pay.invoice_id = inv_id
    credit_pay.payment_amount = amount
    credit_pay.save
  end
  def client_credit
   
  end
end
