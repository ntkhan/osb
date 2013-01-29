class ClientContact < ActiveRecord::Base
  attr_accessible :client_id, :email, :first_name, :last_name,:home_phone, :mobile_number
  belongs_to :client
  acts_as_archival
  acts_as_paranoid
end
