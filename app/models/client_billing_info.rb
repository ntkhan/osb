class ClientBillingInfo < ActiveRecord::Base
  attr_accessible :city, :country, :fax, :notes, :phone_business, :phone_home, :phone_mobile, :postal_or_zip_code, :province_or_state, :street_address_1, :street_address_2
end
