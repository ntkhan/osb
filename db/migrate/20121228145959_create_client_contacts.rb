class CreateClientContacts < ActiveRecord::Migration
  def change
    create_table :client_contacts do |t|
      t.integer :client_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone1
      t.string :phone2

      t.timestamps
    end
  end
end
