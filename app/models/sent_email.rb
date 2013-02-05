class SentEmail < ActiveRecord::Base
  attr_accessible :date, :recipient, :sender, :type, :subject,:content
  paginates_per 10
  default_scope order('created_at DESC')
end
