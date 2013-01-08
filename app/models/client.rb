class Client < ActiveRecord::Base
  attr_accessible :address_street1, :address_street2, :business_phone, :city, :company_size, :country, :fax, :industry, :internal_notes, :organization_name, :postal_zip_code, :province_state, :send_invoice_by ,:email, :home_phone, :first_name, :last_name, :mobile_number,:client_contacts_attributes
  has_many :invoices
  has_many :client_contacts
  accepts_nested_attributes_for :client_contacts, :allow_destroy => true

  def contact_name
    "#{self.first_name} #{self.last_name}"
  end
end
