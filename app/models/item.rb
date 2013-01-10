class Item < ActiveRecord::Base
  attr_accessible :inventory, :item_description, :item_name, :quantity, :tax_1, :tax_2, :track_invetory, :unit_cost
  has_many :line_items
  belongs_to :tax1, :foreign_key => "tax_1", :class_name => "Tax"
  belongs_to :tax2, :foreign_key => "tax_2", :class_name => "Tax"
end
