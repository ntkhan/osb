class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :invoice
  has_many :invoice_line_items
  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :tems, :invoice_line_items_attributes
  accepts_nested_attributes_for :invoice_line_items, :allow_destroy => true
  class << self
    def get_next_invoice_number user_id
      ((Invoice.maximum("id") || 0) + 1).to_s.rjust(5, "0")
    end
  end
end
