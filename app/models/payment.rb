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
      paid_amount = self.invoice_paid_amount py.invoice_id
      py.payment_amount = py.payment_amount - paid_amount
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
  def client_credit client_id
    invoice_ids =  Invoice.where("client_id = ?",client_id).all
    # total credit
    client_payments = Payment.where("payment_type = 'credit' AND invoice_id in (?)", invoice_ids).all
    client_total_credit =  client_payments.sum{|f| f.payment_amount}
    # avail credit
    client_payments = Payment.where("payment_method = 'credit' AND invoice_id in (?)", invoice_ids).all
    client_avail_credit =  client_payments.sum{|f| f.payment_amount}
    balance = client_total_credit - client_avail_credit
    return balance
  end
  def self.invoice_paid_amount inv_id
    invoice_payments = self.invoice_paid_detail(inv_id)
    invoice_paid_amount =  invoice_payments.sum{|f| f.payment_amount}
    return  invoice_paid_amount
  end
  def self.invoice_paid_detail inv_id
    Payment.find_all_by_invoice_id inv_id
  end
end
