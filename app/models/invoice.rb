class Invoice < ActiveRecord::Base
  belongs_to :client
  belongs_to :invoice
  has_many :invoice_line_items
  has_many :payments
  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :terms, :invoice_total, :invoice_line_items_attributes
  accepts_nested_attributes_for :invoice_line_items, :allow_destroy => true
  class << self
    def get_next_invoice_number user_id
      ((Invoice.maximum("id") || 0) + 1).to_s.rjust(5, "0")
    end
  end

  def description
    "Invoice Description"
  end

  def total
    self.invoice_line_items.sum{|li| (li.item_unit_cost || 0) *(li.item_quantity || 0)}
  end

  def duplicate_invoice
    new_invoice = self.dup
    new_invoice.invoice_line_items << self.invoice_line_items.map{|line_item| line_item.dup}
    new_invoice.save
    new_invoice
  end
end
