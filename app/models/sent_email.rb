class SentEmail < ActiveRecord::Base
  attr_accessible :date, :recipient, :sender, :type, :subject,:content
  belongs_to :notification, :polymorphic => true
  self.inheritance_column = :_type_disabled
  paginates_per 10
  default_scope order('created_at DESC')
end
