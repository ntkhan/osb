class Tax < ActiveRecord::Base
  attr_accessible :name, :percentage
  has_many :invoice_line_items
  has_many :items
  validates :name, :presence => true
  validates :percentage, :presence => true
  paginates_per 4
  default_scope order('created_at DESC')
end
