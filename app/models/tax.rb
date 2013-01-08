class Tax < ActiveRecord::Base
  attr_accessible :name, :percentage
  belongs_to :line_items
  belongs_to :items
end
