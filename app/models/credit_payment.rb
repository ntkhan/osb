class CreditPayment < ActiveRecord::Base
  # attr
  attr_accessible :amount, :invoice_id, :payment_id, :credit_id

  # associations
  belongs_to :invoice
  belongs_to :payment

  # callbacks
  after_destroy :update_credit_applied

  def update_credit_applied
      payment.update_attributes(:credit_applied => payment.credit_applied - amount) if payment.present?
  end
end
