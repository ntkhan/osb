class CreditPayment < ActiveRecord::Base
  attr_accessible :amount, :invoice_id, :payment_id, :credit_id
  belongs_to :invoice
  belongs_to :payment
end
