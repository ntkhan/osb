class Client < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_login, :last_name, :organization, :password, :sec_adrs_city, :sec_adrs_country, :sec_adrs_post_or_zip_code, :sec_adrs_province_or_state, :sec_adrs_street_address_1, :sec_adrs_street_address_2, :status, :user_name
end
