class ClientContact < ActiveRecord::Base
  attr_accessible :client_id, :email, :first_name, :last_name, :phone1, :phone2
end
