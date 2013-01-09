class Tax < ActiveRecord::Base
  attr_accessible :name, :percentage
  has_many :invoice_line_items
  has_many :items
end
