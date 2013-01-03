class Item < ActiveRecord::Base
  attr_accessible :inventory, :item_description, :item_name, :quantity, :tax_1, :tax_2, :track_invetory, :unit_cost
  has_many :line_items
end
