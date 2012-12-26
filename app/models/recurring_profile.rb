class RecurringProfile < ActiveRecord::Base
  attr_accessible :client_id, :discount_amount, :discount_percentage, :first_invoice_date, :frequency, :gateway_id, :notes, :occurrences, :po_number, :prorate, :prorate_for, :status, :sub_total, :tax_amount, :tems
end
