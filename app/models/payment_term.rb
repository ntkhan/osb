class PaymentTerm < ActiveRecord::Base
  attr_accessible :description, :number_of_days
  has_many :invoices
end
