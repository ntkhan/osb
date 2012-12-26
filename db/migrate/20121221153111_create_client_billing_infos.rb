class CreateClientBillingInfos < ActiveRecord::Migration
  def change
    create_table :client_billing_infos do |t|
      t.string :country
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :province_or_state
      t.string :postal_or_zip_code
      t.string :phone_business
      t.string :phone_mobile
      t.string :phone_home
      t.string :fax
      t.string :notes

      t.timestamps
    end
  end
end
