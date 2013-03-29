class PaymentTerm < ActiveRecord::Base
  # attr
  attr_accessible :description, :number_of_days

  # associations
  has_many :invoices
end
