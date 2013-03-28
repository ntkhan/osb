class ClientAdditionalContact < ActiveRecord::Base
  # attr
  attr_accessible :client_id, :email, :first_name, :last_name, :password, :phone_1, :phone_2, :user_name
end
