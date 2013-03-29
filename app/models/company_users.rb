class CompanyUsers < ActiveRecord::Base
  # attr
  attr_accessible :company_id, :user_id

  # associations
  belongs_to :user
  belongs_to :company
end
