class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :organization_name
      t.string :send_invoice_by
      t.string :country
      t.string :address_street1
      t.string :address_street2
      t.string :city
      t.string :province_state
      t.string :postal_zip_code
      t.string :industry
      t.string :company_size
      t.string :business_phone
      t.string :fax
      t.text :internal_notes

      t.timestamps
    end
  end
end
