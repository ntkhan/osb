class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :organization
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :user_name
      t.string :password
      t.string :sec_adrs_country
      t.string :sec_adrs_street_address_1
      t.string :sec_adrs_street_address_2
      t.string :sec_adrs_city
      t.string :sec_adrs_province_or_state
      t.string :sec_adrs_post_or_zip_code
      t.string :status
      t.datetime :last_login

      t.timestamps
    end
  end
end
