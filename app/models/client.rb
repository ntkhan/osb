class Client < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  attr_accessible :address_street1, :address_street2, :business_phone, :city, :company_size, :country, :fax, :industry, :internal_notes, :organization_name, :postal_zip_code, :province_state, :send_invoice_by, :email, :home_phone, :first_name, :last_name, :mobile_number, :client_contacts_attributes, :archive_number, :archived_at, :deleted_at
  has_many :invoices
  has_many :client_contacts, :dependent => :destroy
  accepts_nested_attributes_for :client_contacts, :allow_destroy => true
  paginates_per 10
  default_scope order("#{self.table_name}.created_at DESC")

  def contact_name
    "#{self.first_name} #{self.last_name}"
  end

  def last_invoice
    self.invoices.unarchived.last.id rescue nil
  end

  def purchase_options
    {
        :ip => OSB::Util.local_ip,
        :billing_address => {
            :name => self.organization_name.strip! || 'Arif Khan',
            :address1 => self.address_street1 || '1 Main St',
            :city => self.city || 'San Jose',
            :state => self.province_state || 'CA',
            :country => self.country || 'US',
            :zip => self.postal_zip_code || '95131'
        }
    }
  end

  def get_credit_card
    ActiveMerchant::Billing::CreditCard.new(
        :type => 'visa',
        :first_name => 'Arif',
        :last_name => 'Khan',
        :number => '4650161406428289',
        :month => '8',
        :year => '2015',
        :verification_value => '123'
    )
  end

  def self.multiple_clients ids
    ids = ids.split(",") if ids and ids.class == String
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
    ids = ids.split(',') if ids and ids.class == String
    where('id IN(?)', ids).only_deleted.each do |client|
      client.recover
      client.unarchive
    end
  end

  def self.filter params
    case params[:status]
      when 'active' then
        self.unarchived.page(params[:page]).per(params[:per])
      when 'archived' then
        self.archived.page(params[:page]).per(params[:per])
      when 'deleted' then
        self.only_deleted.page(params[:page]).per(params[:per])
      else
        self.unarchived.page(params[:page]).per(params[:per])
    end
  end
end
