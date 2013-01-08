class InvoiceLineItem < ActiveRecord::Base
  attr_accessible :invoice_id, :item_description, :item_id, :item_name, :item_quantity, :item_unit_cost, :tax_1, :tax_2
  belongs_to :invoice
  has_many :items
  has_many :taxes, :foreign_key => ["tax_1","tax_2"]
end
