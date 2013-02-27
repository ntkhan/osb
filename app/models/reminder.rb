class Reminder < ActiveModel::Base
  has_many :sent_emails, :as => :notification
end