class InvoiceLineItem < ActiveRecord::Base
  attr_accessible :invoice_id, :item_description, :item_id, :item_name, :item_quantity, :item_unit_cost, :tax_1, :tax_2
  belongs_to :invoice
  has_many :items
  belongs_to :tax1, :foreign_key => "tax_1", :class_name => "Tax"
  belongs_to :tax2, :foreign_key => "tax_2", :class_name => "Tax"
end
