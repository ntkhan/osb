class InvoiceLineItem < ActiveRecord::Base
  # attr
  attr_accessible :invoice_id, :item_description, :item_id, :item_name, :item_quantity, :item_unit_cost, :tax_1, :tax_2

  # associations
  belongs_to :invoice
  belongs_to :item
  belongs_to :tax1, :foreign_key => 'tax_1', :class_name => 'Tax'
  belongs_to :tax2, :foreign_key => 'tax_2', :class_name => 'Tax'

  # archive and delete
  acts_as_archival
  acts_as_paranoid
end
