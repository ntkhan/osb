class Company < ActiveRecord::Base
  attr_accessible :admin_billing_rate_per_hour, :admin_email, :admin_first_name, :admin_last_name, :admin_password, :admin_user_name, :auto_dst_adjustment, :city, :country, :currency_symbol, :currency_code, :email, :fax, :org_name, :phone_business, :phone_mobile, :postal_or_zip_code, :profession, :province_or_state, :street_address_1, :street_address_2, :time_zone

  #has_many :users, :through => :company_users
  has_and_belongs_to_many :users, :join_table => "company_users"

  before_save :change_currency_symbol

  def change_currency_symbol
    self.currency_symbol = CURRENCY_SYMBOL[self.currency_code]
  end
end
