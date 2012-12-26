class CompanyProfile < ActiveRecord::Base
  attr_accessible :admin_billing_rate_per_hour, :admin_email, :admin_first_name, :admin_last_name, :admin_password, :admin_user_name, :auto_dst_adjustment, :city, :country, :currecy_symbol, :currency_code, :email, :fax, :org_name, :phone_business, :phone_mobile, :postal_or_zip_code, :profession, :province_or_state, :street_address_1, :street_address_2, :time_zone
end
