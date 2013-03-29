class SentEmail < ActiveRecord::Base
  # attr
  attr_accessible :date, :recipient, :sender, :type, :subject, :content

  # associations
  belongs_to :notification, :polymorphic => true
  self.inheritance_column = :_type_disabled

  paginates_per 10
end
