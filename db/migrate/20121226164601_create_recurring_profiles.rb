class CreateRecurringProfiles < ActiveRecord::Migration
  def change
    create_table :recurring_profiles do |t|
      t.datetime :first_invoice_date
      t.string :po_number
      t.decimal :discount_percentage
      t.string :frequency
      t.integer :occurrences
      t.boolean :prorate
      t.decimal :prorate_for
      t.integer :gateway_id
      t.integer :client_id
      t.text :tems
      t.text :notes
      t.string :status
      t.decimal :sub_total
      t.decimal :discount_amount
      t.decimal :tax_amount

      t.timestamps
    end
  end
end
