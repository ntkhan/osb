class CreateClientAdditionalContacts < ActiveRecord::Migration
  def change
    create_table :client_additional_contacts do |t|
      t.integer :client_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_1
      t.string :phone_2
      t.string :user_name
      t.string :password

      t.timestamps
    end
  end
end
