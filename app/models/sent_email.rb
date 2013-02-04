class SentEmail < ActiveRecord::Base
  attr_accessible :date, :recipient, :sender, :type, :subject,:content
  paginates_per 10
 
end
