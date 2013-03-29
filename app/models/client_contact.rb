class ClientContact < ActiveRecord::Base
  # attr
  attr_accessible :client_id, :email, :first_name, :last_name, :home_phone, :mobile_number

  # associations
  belongs_to :client

  # archive and delete
  acts_as_archival
  acts_as_paranoid
end
