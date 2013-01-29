class Client < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  attr_accessible :address_street1, :address_street2, :business_phone, :city, :company_size, :country, :fax, :industry, :internal_notes, :organization_name, :postal_zip_code, :province_state, :send_invoice_by ,:email, :home_phone, :first_name, :last_name, :mobile_number,:client_contacts_attributes, :archive_number, :archived_at, :deleted_at
  has_many :invoices
  has_many :client_contacts, :dependent => :destroy
  accepts_nested_attributes_for :client_contacts, :allow_destroy => true
  paginates_per 4
  def contact_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.multiple_clients ids
    where("id IN(?)", ids)
  end

  def self.archive_multiple ids
    self.multiple_clients(ids).each { |client| client.archive }
  end

  def self.delete_multiple ids
    self.multiple_clients(ids).each { |client| client.destroy }
  end

  def self.recover_archived ids
    self.multiple_clients(ids).each { |client| client.unarchive }
  end

  def self.recover_deleted ids
    where("id IN(?)", ids).only_deleted.each do |client|
      client.update_attributes({
      :archive_number => nil,
      :archived_at => nil,
      :deleted_at => nil})
    end
  end

  def self.filter params
    case params[:status]
      when "active"   then self.unarchived.page(params[:page])
      when "archived" then self.archived.page(params[:page])
      when "deleted"  then self.only_deleted.page(params[:page])
    end
  end
end
