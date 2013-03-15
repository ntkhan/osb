class CompanyUsers < ActiveRecord::Base
  attr_accessible :company_id, :user_id
  belongs_to :user
  belongs_to :company
  before_create :set_time_stamps

  def set_time_stamps
    self.created_at = DateTime.now
    self.updated_at = DateTime.now
  end
end
